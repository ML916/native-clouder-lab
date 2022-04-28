# Create secret
resource "google_secret_manager_secret" "secret" {
  secret_id = "my-secret"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "secret-version-data" {
  secret = google_secret_manager_secret.secret.name

  # NOTE: This is terrible, don't do it!
  secret_data = "secret-data"
}


# Provide access
resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:my-service-account@gmail.com"
}


# Deploy service
resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    spec {
      containers {
        image = "gcr.io/cloudrun/hello"
        volume_mounts {
          name = "a-volume"
          mount_path = "/secrets"
        }
      }

      volumes {
        name = "a-volume"
        secret {
          secret_name = google_secret_manager_secret.secret.secret_id
          default_mode = 292 # 0444
          items {
            key = "1"
            path = "my-secret"
            mode = 256 # 0400
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
        metadata.0.annotations,
    ]
  }
}