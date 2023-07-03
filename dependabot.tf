data "google_secret_manager_secret_version" "dependabo_gitlab_access_token" {
  secret   = "dependabot-gitlab-access-token"
  project  = var.gcp_project_id
  version  = 1
}

data "google_secret_manager_secret_version" "dependabo_github_access_token" {
  secret   = "dependabot-github-access-token"
  project  = var.gcp_project_id
  version  = 1
}

data "google_secret_manager_secret_version" "dependabot_mongodb_passwd" {
  secret   = "dependabot-mongodb-passwd"
  project  = var.gcp_project_id
  version  = 1
}

data "google_secret_manager_secret_version" "dependabot_redis_passwd" {
  secret   = "dependabot-redis-passwd"
  project  = var.gcp_project_id
  version  = 1
}

resource "kubernetes_secret" "dependabot_gitlab_access_token_secret" {
  metadata {
    name      = "depndabot-config-secrets"
    namespace = "dependabot"
  }
  data = {
    SETTINGS__GITLAB_ACCESS_TOKEN = data.google_secret_manager_secret_version.dependabo_gitlab_access_token.secret_data,
    SETTINGS__GITHUB_ACCESS_TOKEN = data.google_secret_manager_secret_version.dependabo_github_access_token.secret_data,
    REDIS_PASSWORD = data.google_secret_manager_secret_version.dependabot_redis_passwd.secret_data,
    MONGODB_PASSWORD = data.google_secret_manager_secret_version.dependabot_mongodb_passwd.secret_data
  }
}