data "google_secret_manager_secret" "secret" {
  secret_id = "foobar-whatever-secret"
}

resource "google_secret_manager_secret_iam_member" "secret-access" {
  secret_id = google_secret_manager_secret.secret.secret_id
  role      = "roles/secretmanager.secretAccessor"
  member    = "serviceAccount:123456789-compute@developer.gserviceaccount.com"
}

resource "google_cloud_run_service" "default" {
  name     = "cloudrun-srv"
  location = "us-central1"

  template {
    spec {
      container_concurrency = 0
      timeout_seconds      = 10

      containers {
        image = "us-docker.pkg.dev/cloudrun/container/hello"

        command = ["/hello"]

        env {
          name = "ENVIRONMENT"
          value = "dev"
        }

        resource {
          requests {
            cpu = "500m"
            memory = "1024Mi"
          }
        }

        env {
          name = "SECRET_ENV_VAR"
          value_from {
            secret_key_ref {
              name = google_secret_manager_secret.secret.secret_id
              key = "9"
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