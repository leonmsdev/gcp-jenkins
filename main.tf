data "google_client_config" "executor" {}

data "google_project" "gcp_jenkins_project" {
  project_id = var.gcp_project_id
}
