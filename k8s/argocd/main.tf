terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.0.0"
    }
  }
}

# Create ArgoCD namespace
resource "kubernetes_namespace" "argocd" {
  metadata {
    name = var.argocd_namespace
    labels = {
      name = "argocd"
    }
  }
}

# Install ArgoCD using Helm
resource "helm_release" "argocd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  timeout    = 1800

  # Use values parameter to configure ArgoCD, making it easier to read and maintain
  values = [
    <<-EOT
    # Server configuration
    server:
      # Use LoadBalancer type for easier external access
      service:
        type: LoadBalancer
      # Allow HTTP access to avoid certificate warnings
      insecure: true

    # Key configuration
    configs:
      # Create initial admin password secret
      secret:
        createSecret: true
      # Configure Git repositories
      repositories:
        app-repo:
          url: "${var.git_repository_url}"
          type: "git"
    EOT
  ]
}
