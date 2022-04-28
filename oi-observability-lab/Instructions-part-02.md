# <img src="/assets/images/ITOI.png" alt="OpenTelemetry Icon" width="45" height=""> OI Observability Lab
[![operational-intelligence](https://img.shields.io/static/v1?label=oi&message=opi&color=white&logo=data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAA4AAAAOCAYAAAAfSC3RAAAAv0lEQVQoFX2SWxLDIAhFY6fL0e0lG81+Wg/1MDTTlA/F+wBMbK8ZW4nWWpyEr2elTxN2RHeGyqF9sBAQvfdtjPEBygoGZ/fQO6oV3YsvJ6lcdBSgsqMex5HdweTQEnlHhOd5BmghDuZwaGowbca8S+T7vidWc8Bpjj8Rgn8GOfcvY5ZfFe2C6BphBCRBuCqFjurVXDXhCdUykzuOeMUwG41kAvn1yAk/+6IT85wvJ5i53L0ceffsCGAXciv/wuDfxMQi4xzpAiQAAAAASUVORK5CYII=)](https://github.com/orgs/ingka-group-digital/teams/opi-observability-pipeline)
[![Slack](https://img.shields.io/badge/join%20slack-%23sig--observability-brightgreen.svg)](https://ingka.slack.com/channels/CQ8LHD0KC)

# Part 02: Build and Deploy Application

## Building - Cloud Build

We will use Cloud Build in GCP to create container images with our application and the OpenTelemetry Collector. Cloud Build can be connected to a code repository and trigger a build pipeline based on configured events. When creating a trigger, the Cloud Build configuration file can either be retrived from your code repository or written inline in YAML.

## Connecting Cloud Build to GitHub
Google Cloud Platform -> Cloud Build -> Triggers

Connect Repository

* GitHub -> Continue
* Select your GitHub Account
* Choose between all repos or selected repos
* Authorize Google Cloud Build Permissions
* Select the oi-observability-lab repo
* Click Create a Trigger

Important. The Cloud Build configuration files in the code repository will build images that prefix your image names with the name of your trigger. You should name your triggers with your IKEA id and what it triggers: ``gcp_username-app`` and ``gcp_username-otel``. The terraform will depend on this. If your username has an underscore in it, replace it with hyphen. If you are unsure of your username it should be in your Cloud Shell Prompt or you can run the following in cloud shell:
```
echo $USER
```

You will also need to add a ``dir`` attribute for your build step to make sure that the trigger find the required files.

* Add a Description of your app, select Manual invocation or Push to a branch depending on what you prefer.
* Select your repo
* Revision->Branch
* Choose the branch you wish to use. Main is default.
* Configuration->Cloud Build configuration file
* Location->Repository

Cloud build location file:
* Inline

Click Open Editor and paste the corresponding section of cloud build yaml into the editor and save.

Click *Create*


### Cloud Build YAML for Application

````yaml
steps:

# Build the container image
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'europe-west4-docker.pkg.dev/$PROJECT_ID/native-clouders/$TRIGGER_NAME-jsonservice:latest', '-f', 'Dockerfile.jsonservice', '.']
  dir: labs/oi-observability-lab
   
# Push the container image to Container Registry
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'europe-west4-docker.pkg.dev/$PROJECT_ID/native-clouders/$TRIGGER_NAME-jsonservice']
````

### Cloud Build YAML for the OpenTelemetry Collector

````yaml
steps:

# Build the container image
- name: 'gcr.io/cloud-builders/docker'
  args: ['build', '-t', 'europe-west4-docker.pkg.dev/$PROJECT_ID/native-clouders/$TRIGGER_NAME-otelcollectorjson:latest', '-f', 'Dockerfile.otelcollectorjson', '.']
  dir: labs/oi-observability-lab

# Push the container image to Container Registry
- name: 'gcr.io/cloud-builders/docker'
  args: ['push', 'europe-west4-docker.pkg.dev/$PROJECT_ID/native-clouders/$TRIGGER_NAME-otelcollectorjson']
````


## Deploying - Terraform

We will deploy our application and the OpenTelemetry Collector using Terraform. In our setup, the application has a dependency on the OpenTelemetry collector HTTPS endpoint. In addition to full control of setup and tear down of our utilized resources, Terraform also helps us to manage these dependencies and set the required details accordingly. Terraform is using a state file to keep track of resources. It will be stored in a bucket i GCP. We need to create the bucket, change a few variables, and make sure that the secrets we'll need are configured in the GCP Secret Manager.


### Create bucket in GCP
Create bucket in gcp that will contain your terraform state file.
``` sh
gsutil mb -p $DEVSHELL_PROJECT_ID -l eu gs://$USER-tf-state-bucket
```

Open [main.tf](main.tf)
Update backend with created bucket
````  yaml
terraform {
  backend "gcs" {
    bucket = "<USER>-tf-state-bucket"
    prefix = "oi-o11y-native-clouders-oi-lab/tfstate"
  }
}
````

### Update variables
Open [variables.tf](variables.tf)
Update variables with correct content. Be sure to replace _ with - in the username to match your cloud build artifacts.
```` yaml
variable "user" {
  description = "Name of the user running tf."
  default     = "<USER>"
}
````
```` yaml
variable "provider_project" {
  description = "Name of project."
  default     = "<PROVIDER_PROJECT>"
}
````

### Secrets
Create secrets if not created
````
XML_SERVICE_URL
SFX_INGEST_TOKEN
````

Verify the content with ``terraform apply`` 
