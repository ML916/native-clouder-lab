#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters";
    echo "bootstrap.sh /path/to/account.json /path/to/secrets/dir/"
    exit 1
fi

CREDENTIALS=$1
SECRETS_DIR=$2
shift

ACCOUNT=$(cat ${CREDENTIALS} | jq -r .client_email)
PROJECT_ID=$(cat ${CREDENTIALS} | jq -r .project_id)
SERVICE_ACCOUNT="deploy@${PROJECT_ID}.iam.gserviceaccount.com"

if [ -z "${PROJECT_ID}" ]; then
    echo "Unable to determin project ID"
    exit 1
fi

if [ -z "${ACCOUNT}" ]; then
    echo "Unable to determin service account detials"
    exit 1
fi
# Log in as service account
gcloud auth activate-service-account ${ACCOUNT} \
    --key-file=${CREDENTIALS} --project=${PROJECT_ID}

#Create service Account
gcloud iam service-accounts describe ${SERVICE_ACCOUNT} || gcloud iam service-accounts create deploy \
    --description "initial terraform user, created through bootstrap script"

#Grant roles to service account
for role in owner resourcemanager.projectIamAdmin secretmanager.admin storage.admin
do
  gcloud projects add-iam-policy-binding ${PROJECT_ID} \
    --member serviceAccount:${SERVICE_ACCOUNT} \
    --role roles/${role}
done

# Enable API services
gcloud services enable \
    cloudresourcemanager.googleapis.com \
    run.googleapis.com \
    compute.googleapis.com \
    iam.googleapis.com \
    secretmanager.googleapis.com \
    artifactregistry.googleapis.com \
    --project=${PROJECT_ID}

# Create SA key file
gcloud iam service-accounts keys create ${SECRETS_DIR}/terraform-service-account \
  --iam-account deploy@${PROJECT_ID}.iam.gserviceaccount.com

# Add secrets
for secret in github-webhook-secret project-deploy-key terraform-deploy-key \
  terraform-service-account slack-url
do
  gcloud secrets create ${secret} --replication-policy=automatic
  gcloud secrets versions add ${secret} --data-file=${SECRETS_DIR}/${secret}
done

# Create state bucket
gsutil mb -c standard -l europe-west3 -p ${PROJECT_ID} gs://${PROJECT_ID}

# Create npm repo if not exist
NPM_REPONAME=npm
gcloud beta artifacts repositories get-iam-policy ${NPM_REPONAME} \
    --location=europe-west3 ||  \
  gcloud beta artifacts repositories create ${NPM_REPONAME} \
    --repository-format=npm --location=europe-west3