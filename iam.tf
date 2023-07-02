locals {
  gcp_bindings = {
    "roles/secretmanager.admin" = [
      format("serviceAccount:%s", google_service_account.secret_manager_sa.email)
    ],
  }
}

resource "google_project_iam_policy" "gcp_project_iam" {
  project     = var.gcp_project_id
  policy_data = data.google_iam_policy.google_iam[0].policy_data
}

data "google_iam_policy" "google_iam" {
  for_each = local.gcp_bindings
  binding {
    role    = each.key
    members = each.value
  }
}