terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.70.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }
    google-beta = {
      source  = "hashicorp/google"
      version = "~> 4.0"
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
    config_path = var.kube_config
  }
}

provider "kubernetes" {
  config_path = var.kube_config
}

provider "kubernetes-alpha" {
  config_path = var.kube_config
}