terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

# Kubernetes Provider configuration - using local kubeconfig
provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = var.k8s_context_name
}

# Helm Provider configuration - using local kubeconfig
provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = var.k8s_context_name
  }
}

# Deploy ArgoCD
module "argocd" {
  source = "./argocd"
  
  # Additional configuration
  argocd_namespace   = var.argocd_namespace
  argocd_version     = var.argocd_version
  git_repository_url = var.git_repository_url
} 