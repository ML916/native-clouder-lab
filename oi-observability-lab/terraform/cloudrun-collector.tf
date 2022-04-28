resource "google_cloud_run_service" "native_clouders_otelcollectorjson" {
  name     = "${var.user}-otelcollectorjson-tf"
  location = var.provider_region

  template {
    spec {
      containers {
        image = "${var.provider_region}-docker.pkg.dev/${var.provider_project}/native-clouders/${var.user}-${var.json_collector_image}"
        env {
          name = "GCP_PROJECT"
          value = var.project_name
        }
        env {
          name = "SFX_INGEST_TOKEN"
          value_from {
            secret_key_ref {
              name = data.google_secret_manager_secret.sfx_ingest_token.secret_id
              key = "latest"
            }
          }
        }
        env {
          name = "XML_OTEL_COLLECTOR_URL"
          value = var.xml_otel_collector_url
        }
        ports {
          container_port = 4318
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run_api]
}

resource "google_cloud_run_service_iam_member" "run_all_users_collector" {
  service  = google_cloud_run_service.native_clouders_otelcollectorjson.name
  location = google_cloud_run_service.native_clouders_otelcollectorjson.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}
