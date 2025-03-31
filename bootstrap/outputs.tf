output "resource_group_name" {
  description = "The name of the resource group for Terraform state storage"
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "The name of the storage account for Terraform state storage"
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "The name of the blob container for Terraform state files"
  value       = azurerm_storage_container.tfstate.name
}

output "backend_config_template" {
  description = "A template for backend configuration that can be used in other Terraform configurations"
  value       = <<-EOT
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
    container_name       = "${azurerm_storage_container.tfstate.name}"
    key                  = "ENVIRONMENT_NAME.terraform.tfstate"  # Replace ENVIRONMENT_NAME with your environment (e.g., dev, test)
  }
}
EOT
} 