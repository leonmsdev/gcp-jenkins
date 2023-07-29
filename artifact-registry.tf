resource "google_project_service" "artifact_registry" {
  project = var.gcp_project_id
  service = "artifactregistry.googleapis.com"
}

resource "google_artifact_registry_repository" "hochzeitsauto_schwerin" {
  location      = var.gcp_region
  repository_id = "hochzeitsauto-schwerin"
  description   = "Holds Docker Builds of hochzeitsauto-schwerin"
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry]
}