# Credentials from the infra module
variable "aks_host" {
  description = "AKS cluster API server address"
  type        = string
  default     = ""
}

variable "aks_client_certificate" {
  description = "AKS cluster client certificate"
  type        = string
  default     = ""
}

variable "aks_client_key" {
  description = "AKS cluster client key"
  type        = string
  default     = ""
}

variable "aks_cluster_ca_certificate" {
  description = "AKS cluster CA certificate"
  type        = string
  default     = ""
}

variable "k8s_context_name" {
  description = "Kubectl configuration context name"
  type        = string
  default     = ""
}

# ArgoCD配置
variable "argocd_namespace" {
  description = "ArgoCD installed namespace"
  type        = string
  default     = "argocd"
}

variable "argocd_version" {
  description = "ArgoCD Helm chart version"
  type        = string
  default     = "5.51.2"  # Appropriate version number
}

variable "git_repository_url" {
  description = "ArgoCD default Git repository URL"
  type        = string
  default     = "https://github.com/chienaeae/music-activity-processing-system"
} 