resource "kubernetes_namespace" "dependabot" {
  metadata {
    name = "dependabot"
  }
}

data "google_secret_manager_secret_version" "dependabo_gitlab_access_token" {
  secret  = "dependabot-gitlab-access-token"
  project = var.gcp_project_id
  version = 1
}

data "google_secret_manager_secret_version" "dependabo_github_access_token" {
  secret  = "dependabot-github-access-token"
  project = var.gcp_project_id
  version = 1
}

data "google_secret_manager_secret_version" "dependabot_mongodb_root_passwd" {
  secret  = "dependabot-mongodb-root-passwd"
  project = var.gcp_project_id
  version = 1
}

data "google_secret_manager_secret_version" "dependabot_mongodb_passwd" {
  secret  = "dependabot-mongodb-passwd"
  project = var.gcp_project_id
  version = 1
}

data "google_secret_manager_secret_version" "dependabot_redis_passwd" {
  secret  = "dependabot-redis-passwd"
  project = var.gcp_project_id
  version = 1
}

resource "kubernetes_secret" "dependabot_config_secrets" {
  metadata {
    name      = "depndabot-config-secrets"
    namespace = kubernetes_namespace.dependabot.metadata[0].name
  }
  data = {
    SETTINGS__GITLAB_ACCESS_TOKEN = data.google_secret_manager_secret_version.dependabo_gitlab_access_token.secret_data,
    SETTINGS__GITHUB_ACCESS_TOKEN = data.google_secret_manager_secret_version.dependabo_github_access_token.secret_data,
    REDIS_PASSWORD                = data.google_secret_manager_secret_version.dependabot_redis_passwd.secret_data,
    MONGODB_PASSWORD              = data.google_secret_manager_secret_version.dependabot_mongodb_passwd.secret_data
  }
}

resource "kubernetes_secret" "dependabot_mongodb_secrets" {
  metadata {
    name      = "dependabot-mongodb"
    namespace = kubernetes_namespace.dependabot.metadata[0].name
  }
  data = {
    mongodb-passwords     = data.google_secret_manager_secret_version.dependabot_mongodb_passwd.secret_data,
    mongodb-root-password = data.google_secret_manager_secret_version.dependabot_mongodb_root_passwd.secret_data
  }
}

resource "kubernetes_secret" "dependabot_redis_secrets" {
  metadata {
    name      = "depndabot-redis"
    namespace = kubernetes_namespace.dependabot.metadata[0].name
  }
  data = {
    redis-password = data.google_secret_manager_secret_version.dependabot_redis_passwd.secret_data
  }
}