output "aks_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "aks_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "kube_config" {
  description = "Kubernetes configuration"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "Kubernetes API server hostname"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "client_certificate" {
  description = "Kubernetes client certificate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "client_key" {
  description = "Kubernetes client key"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Kubernetes cluster CA certificate"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "application_insights_key" {
  description = "Application Insights instrumentation key"
  value       = azurerm_application_insights.main.instrumentation_key
  sensitive   = true
}

output "application_insights_app_id" {
  description = "Application Insights application ID"
  value       = azurerm_application_insights.main.app_id
} 