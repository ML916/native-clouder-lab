### Pre-req
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

Open [variables.tf](variables.tf)
Update variables with correct content
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

Create secrets if not created
````
XML_SERVICE_URL
SFX_INGEST_TOKEN
````

Verify the content with ``terraform apply`` 
