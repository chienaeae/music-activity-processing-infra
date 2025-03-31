variable "host" {
  description = "Kubernetes API server endpoint"
  type        = string
  default     = ""
}

variable "client_certificate" {
  description = "Base64 encoded client certificate for Kubernetes authentication"
  type        = string
  default     = ""
}

variable "client_key" {
  description = "Base64 encoded client key for Kubernetes authentication"
  type        = string
  default     = ""
}

variable "cluster_ca_certificate" {
  description = "Base64 encoded cluster CA certificate for Kubernetes authentication"
  type        = string
  default     = ""
}

variable "argocd_namespace" {
  description = "ArgoCD namespace"
  type        = string
  default     = "argocd"
}

variable "argocd_version" {
  description = "ArgoCD helm chart version"
  type        = string
  default     = "5.51.2"
}

variable "git_repository_url" {
  description = "ArgoCD default Git repository URL"
  type        = string
  default     = "https://github.com/chienaeae/music-activity-processing-system"
}
