terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.70.0"
    }
    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.20.0"
    }
  }

  backend "gcs" {
    bucket = "jenkins-tfstate-collie"
    prefix = "terraform/state"
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "google-beta" {
  project = var.gcp_project_id
  region  = var.gcp_region
}

provider "helm" {
  kubernetes {
    host                   = format("https://%s", google_container_cluster.worker_cluster.endpoint)
    cluster_ca_certificate = base64decode(google_container_cluster.worker_cluster.master_auth.0.cluster_ca_certificate)
    token                  = data.google_client_config.executor.access_token
  }
}

provider "kubernetes" {
  host                   = format("https://%s", google_container_cluster.worker_cluster.endpoint)
  cluster_ca_certificate = base64decode(google_container_cluster.worker_cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.executor.access_token
  load_config_file       = false
}

provider "kubernetes-alpha" {
  host                   = format("https://%s", google_container_cluster.worker_cluster.endpoint)
  cluster_ca_certificate = base64decode(google_container_cluster.worker_cluster.master_auth.0.cluster_ca_certificate)
  token                  = data.google_client_config.executor.access_token
}
