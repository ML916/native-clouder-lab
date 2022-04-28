variable "project_id" {
    description = "The GCP project ID"
}

variable "image" {
    description = "The image to use for the service"
}

variable "name" {
    description = "The name of the service"
}

variable "location" {
    description = "The location of the service"
}

variable "domain" {
    description = "The domain name"
    default = ""
}

data "google_container_registry_image" "run_api" {
  name    = "hello-app"
  project = "google-samples"
  tag     = "1.0"
}

// resource "google_cloud_domain_mapping" "hello_app" {
//   count = var.domain == "" ? 0 : 1
//   domain = var.domain
//   service = google_cloud_run_service.default.name
// }

resource "google_cloud_run_service" "default" {
  name     = var.name
  location = var.location
  project  = var.project_id

  template {
    spec {
      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

output "id" {
  value = google_cloud_run_service.default.id
}

output "name" {
  value = google_cloud_run_service.default.name
}

output "url" {
  value = google_cloud_run_service.default.status[0].url
}