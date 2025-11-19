terraform {
  required_version = ">= 1.5.0"
  
  backend "gcs" {
    bucket = "YOUR_PROJECT_ID-terraform-state"
    prefix = "prod/gke-ollama"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

data "google_client_config" "default" {}

module "gke" {
  source = "../../modules/gke"
  
  project_id   = var.project_id
  region       = var.region
  cluster_name = var.cluster_name
}

module "monitoring" {
  source = "../../modules/monitoring"
  
  depends_on = [module.gke]
}

module "vault" {
  source = "../../modules/vault"
  
  depends_on = [module.gke]
}