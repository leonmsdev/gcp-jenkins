locals {
  gcp_bindings = {
    "roles/secretmanager.admin" = [
      format("serviceAccount:%s", google_service_account.secret_manager_sa.email)
    ],
  }
}

resource "google_project_iam_policy" "gcp_project_iam" {
  project     = var.gcp_project_id
  policy_data = data.google_iam_policy.google_iam.policy_data
}

data "google_iam_policy" "google_iam" {
  dynamic "binding" {
    for_each = local.gcp_bindings

    content {
      role    = binding.key
      members = binding.value
    }
  }
}