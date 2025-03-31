module "kubernetes_dev" {
  source = "../../"
  
  # Use kubectl context name
  k8s_context_name = "event-proc-dev-aks"
  
  # ArgoCD configuration
  argocd_namespace   = "argocd"
  argocd_version     = "5.51.2"
  git_repository_url = "https://github.com/chienaeae/music-activity-processing-system"
} 