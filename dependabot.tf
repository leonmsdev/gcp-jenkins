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
    #defines secret name and version and the kubernetes key inside the secret                 
    "dependabot-gitlab-access-token" = [1, "token"]
    "dependabot-github-access-token" = [1, "token"]
    "dependabot-mongodb-passwd"      = [1, "passwd"]
    "dependabot-redis-passwd"        = [1, "passwd"]
  }
}

data "google_secret_manager_secret_version" "dependabot_secrets" {
  for_each = local.dependabot_secrets
  secret   = each.key
  project  = var.gcp_project_id
  version  = each.value[0]
}

resource "kubernetes_secret" "dependabot_gitlab_access_token_secret" {
  for_each = local.dependabot_secrets

  metadata {
    name      = trimprefix(each.key, "dependabot-")
    namespace = "dependabot"
  }

  data = {
    each.value[1] = data.google_secret_manager_secret_version.dependabot_secrets[each.index].secret_data
  }
}
