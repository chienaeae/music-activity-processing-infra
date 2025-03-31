output "argocd_namespace" {
  description = "Namespace where ArgoCD is installed"
  value       = kubernetes_namespace.argocd.metadata[0].name
}

output "argocd_server_service" {
  description = "ArgoCD server service name"
  value       = "argocd-server"
}

output "argocd_admin_user" {
  description = "ArgoCD admin username"
  value       = "admin"
}

output "argocd_admin_password_command" {
  description = "Command to get the ArgoCD admin password"
  value       = "kubectl -n ${kubernetes_namespace.argocd.metadata[0].name} get secret argocd-initial-admin-secret -o jsonpath=\"{.data.password}\" | base64 -d"
}
