# Output resource group information
output "resource_group_name" {
  description = "Resource group name"
  value       = azurerm_resource_group.main.name
}

output "resource_group_location" {
  description = "Resource group location"
  value       = azurerm_resource_group.main.location
}

# Output AKS cluster information
output "aks_cluster_name" {
  description = "AKS cluster name"
  value       = module.aks.aks_name
}

output "aks_cluster_id" {
  description = "AKS cluster ID"
  value       = module.aks.aks_id
}

output "aks_kubeconfig" {
  description = "AKS kubeconfig"
  value       = module.aks.kube_config
  sensitive   = true
}

# Output AKS credentials required for k8s phase
output "aks_host" {
  description = "AKS API server endpoint"
  value       = module.aks.host
  sensitive   = true
}

output "aks_client_certificate" {
  description = "AKS client certificate"
  value       = module.aks.client_certificate
  sensitive   = true
}

output "aks_client_key" {
  description = "AKS client key"
  value       = module.aks.client_key
  sensitive   = true
}

output "aks_cluster_ca_certificate" {
  description = "AKS cluster CA certificate"
  value       = module.aks.cluster_ca_certificate
  sensitive   = true
}

# Output ACR information
output "acr_login_server" {
  description = "ACR login server"
  value       = module.acr.acr_login_server
}

output "acr_admin_username" {
  description = "ACR admin username"
  value       = module.acr.admin_username
  sensitive   = true
}

output "acr_admin_password" {
  description = "ACR admin password"
  value       = module.acr.admin_password
  sensitive   = true
}

# Output database information
output "sql_server_name" {
  description = "SQL Server name"
  value       = module.database.sql_server_name
}

output "sql_server_fqdn" {
  description = "SQL Server FQDN"
  value       = module.database.sql_server_fqdn
}

output "sql_database_name" {
  description = "SQL Database name"
  value       = module.database.sql_database_name
}

output "vnet_name" {
  description = "The name of the virtual network"
  value       = module.network.vnet_name
}

output "application_insights_key" {
  description = "The Application Insights instrumentation key"
  value       = module.aks.application_insights_key
  sensitive   = true
} 