data "google_secret_manager_secret" "secret" {
  secret_id = var.secret-name
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:123456789-compute@developer.gserviceaccount.com"
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = var.location

  template {
    spec {
      container_concurrency = var.concurrency
      timeout_seconds       = var.timeout

      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        command = [var.command]

        env {
          name = var.environment-variable-name
          value = var.environment
        }

        resource {
          requests {
            cpu = var.cpi
            memory = var.memory
          }
        }

        env {
          name = "SECRET"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.secret.secret_id
              key = var.secret-version
            }
          }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_storage_bucket" "really-important-bucket" {
  name          = var.bucket-name
  location      = "US"
  force_destroy = true
}