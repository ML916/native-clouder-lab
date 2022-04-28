resource "google_cloud_run_service" "native_clouders_jsonservice" {
  name     = "${var.user}-jsonservice-tf"
  location = var.provider_region

  template {
    spec {
      containers {
        image = "${var.provider_region}-docker.pkg.dev/${var.provider_project}/native-clouders/${var.user}-${var.json_service_image}"
        env {
          name = "XML_SERVICE_URL"
          value_from {
            secret_key_ref {
              name = data.google_secret_manager_secret.xml_service_url.secret_id
              key = "latest"
            }
          }
        }
        env {
          name = "JSON_OTEL_COLLECTOR_URL"
          value = google_cloud_run_service.native_clouders_otelcollectorjson.status[0].url
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
        ports {
          container_port = 8080
        }
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }

  depends_on = [google_project_service.run_api, google_cloud_run_service.native_clouders_otelcollectorjson]
}

resource "google_cloud_run_service_iam_member" "run_all_users_service" {
  service  = google_cloud_run_service.native_clouders_jsonservice.name
  location = google_cloud_run_service.native_clouders_jsonservice.location
  role     = "roles/run.invoker"
  member   = "allUsers"
}

# Return service URL
output "url" {
  value = "${google_cloud_run_service.native_clouders_jsonservice.status[0].url}"
}
