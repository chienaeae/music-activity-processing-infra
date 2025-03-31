resource "azurerm_container_registry" "main" {
  name                = replace("${var.resource_prefix}acr", "-", "")
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  admin_enabled       = false  # Use managed identity instead of admin user
  tags                = var.tags
} 