
provider "google" {
  # Credentials not needed as this tf is run from a cloud shell with Terraform.
  project = var.provider_project
  region  = var.provider_region
  zone    = var.provider_zone
}

provider "google-beta" {
  # Credentials not needed as this tf is run from a cloud shell with Terraform.
  project = var.provider_project
  region  = var.provider_region
  zone    = var.provider_zone
}

# Update bucket with you created bucket.

terraform {
  backend "gcs" {
    bucket = "<USER>-tf-state-bucket"
    prefix = "oi-o11y-native-clouders-oi-lab/tfstate"
  }
}

# Fetch secrets
data "google_secret_manager_secret" "xml_service_url" {
  secret_id = "XML_SERVICE_URL"
}
data "google_secret_manager_secret" "sfx_ingest_token" {
  secret_id = "SFX_INGEST_TOKEN"
}

resource "google_project_service" "run_api" {
  service = "run.googleapis.com"
  disable_on_destroy = false
}


