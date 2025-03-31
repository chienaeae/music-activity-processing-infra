output "vnet_id" {
  description = "ID of the created virtual network"
  value       = azurerm_virtual_network.main.id
}

output "vnet_name" {
  description = "Name of the created virtual network"
  value       = azurerm_virtual_network.main.name
}

output "aks_subnet_id" {
  description = "ID of the AKS subnet"
  value       = azurerm_subnet.aks.id
}

output "db_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.db.id
}

output "aks_nsg_id" {
  description = "ID of the AKS NSG"
  value       = azurerm_network_security_group.aks.id
}

output "db_nsg_id" {
  description = "ID of the database NSG"
  value       = azurerm_network_security_group.db.id
} 