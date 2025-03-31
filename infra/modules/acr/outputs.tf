output "acr_id" {
  description = "ID of the Azure Container Registry"
  value       = azurerm_container_registry.main.id
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = azurerm_container_registry.main.name
}

output "acr_login_server" {
  description = "Login server for the Azure Container Registry"
  value       = azurerm_container_registry.main.login_server
}

output "admin_username" {
  description = "Admin username for the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "Admin password for the Azure Container Registry"
  value       = azurerm_container_registry.main.admin_password
  sensitive   = true
} 