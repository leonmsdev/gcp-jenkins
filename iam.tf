locals {
  gcp_bindings = {
    "roles/secretmanager.admin" = [
      format("serviceAccount:%s", google_service_account.secret_manager_sa.email)
    ],
  }
}

resource "google_project_iam_binding" "iam" {
  for_each = local.gcp_bindings

  project = var.gcp_project_id
  role    = each.key

  members = each.value
}