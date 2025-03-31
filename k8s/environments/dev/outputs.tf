output "argocd_namespace" {
  description = "ArgoCD installed namespace"
  value       = module.kubernetes_dev.argocd_namespace
}

output "argocd_server_service" {
  description = "ArgoCD server service name"
  value       = module.kubernetes_dev.argocd_server_service
}

output "argocd_admin_user" {
  description = "ArgoCD admin username"
  value       = module.kubernetes_dev.argocd_admin_user
}

output "argocd_admin_password_command" {
  description = "Command to get ArgoCD admin password"
  value       = module.kubernetes_dev.argocd_admin_password_command
} 