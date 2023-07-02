# import {
#   to = kubernetes_namespace.dependabot
#   id = "3ebef761-ef77-46ae-86cc-3d12313d0b0b"
# }

# resource "kubernetes_namespace" "dependabot" {
#   metadata {
#     name = "dependabot"
#   }
# }

locals {
  dependabot_secrets = {
    # Defines [0] index, [1] secret version, [2] the version to use and the kubernetes key name inside the secret.
    "dependabot-gitlab-access-token" = [0, 1, "token"], # [0 , 1, 2] *The first index needs to be +1 if a new elemt gets added to the list.
    "dependabot-github-access-token" = [1, 1, "token"],
    "dependabot-mongodb-passwd"      = [2, 1, "passwd"],
    "dependabot-redis-passwd"        = [3, 1, "passwd"]
  }
}

data "google_secret_manager_secret_version" "dependabot_secrets" {
  for_each = local.dependabot_secrets
  secret   = each.key
  project  = var.gcp_project_id
  version  = each.value[1]
}

resource "kubernetes_secret" "dependabot_gitlab_access_token_secret" {
  for_each = local.dependabot_secrets

  metadata {
    name      = trimprefix(each.key, "dependabot-")
    namespace = "dependabot"
  }

  data = {
    format("%s", each.value[2]) = data.google_secret_manager_secret_version.dependabot_secrets[tonumber(format("%s", each.value[0]))].secret_data
  }
}
