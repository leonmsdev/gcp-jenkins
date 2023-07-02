locals {
  secrets = [
    "dependabot-redis-passwd",
    "dependabot-mongodb-passwd",
    "dependabot-gitlab-access-token",
    "dependabot-github-access-token",
  ]
}

resource "google_project_service" "secret_manager" {
  project = var.gcp_project_id
  service = "secretmanager.googleapis.com"
}

resource "google_service_account" "secret_manager_sa" {
  account_id   = "secret-manager"
  display_name = "Secret Manager SA"
}

resource "google_secret_manager_secret" "admin-password" {
  for_each = local.secrets
  #  provider = google-beta
  depends_on = [google_project_service.secret_manager]

  secret_id = each.value
  replication {
    user_managed {
      replicas {
        location = "europe-west4"
      }
    }
  }
}