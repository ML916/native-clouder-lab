#!/bin/bash

EMAIL="my-service-account@gmail.com"

echo "Create secret"

# NOTE: Using secrets in scripts is terrible, don't copy this!!!!
echo -n "secret-data" | gcloud secrets create my-secret \
    --replication-policy="automatic" \
    --data-file=-

echo "Give access"
gcloud secrets add-iam-policy-binding my-secret \
    --member="serviceAccount:${EMAIL}" --role='roles/secretmanager.secretAccessor'

echo "Deploy service"
gcloud run deploy my-service --image gcr.io/cloudrun/hello  \
    --service-account=${EMAIL} \
    --update-secrets=/secrets=my-secret:latest