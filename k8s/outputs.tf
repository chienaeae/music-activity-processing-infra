# Output ArgoCD related information
output "argocd_server_service" {
  description = "ArgoCD service name"
  value       = module.argocd.argocd_server_service
}

output "argocd_namespace" {
  description = "ArgoCD installed namespace"
  value       = module.argocd.argocd_namespace
}

output "argocd_admin_user" {
  description = "ArgoCD admin username"
  value       = module.argocd.argocd_admin_user
}

output "argocd_admin_password_command" {
  description = "Command to get ArgoCD admin password"
  value       = module.argocd.argocd_admin_password_command
} 