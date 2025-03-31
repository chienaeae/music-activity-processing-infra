resource "azurerm_mssql_server" "main" {
  name                         = "${var.resource_prefix}-sqlserver"
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = "12.0"
  administrator_login          = var.admin_username
  administrator_login_password = var.admin_password
  tags                         = var.tags
  
  # Enable encryption
  identity {
    type = "SystemAssigned"
  }
  
  # Enable public network access, but only for specific IPs (in production, disable this option and use private endpoints)
  public_network_access_enabled = true
}

# Create SQL database
resource "azurerm_mssql_database" "main" {
  name           = "${var.resource_prefix}-db"
  server_id      = azurerm_mssql_server.main.id
  sku_name       = var.database_sku
  zone_redundant = var.environment == "prod" ? true : false
  tags           = var.tags
  
  # Short-term backup retention policy
  short_term_retention_policy {
    retention_days = 7
  }
}

# Create firewall rule to allow Azure services access
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Create firewall rule to allow AKS subnet access
resource "azurerm_mssql_virtual_network_rule" "aks_subnet" {
  name      = "aks-subnet"
  server_id = azurerm_mssql_server.main.id
  subnet_id = var.db_subnet_id
}

# Optional: Create SQL server private endpoint
resource "azurerm_private_endpoint" "sql" {
  name                = "${var.resource_prefix}-sql-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.db_subnet_id
  tags                = var.tags

  private_service_connection {
    name                           = "${var.resource_prefix}-sql-psc"
    private_connection_resource_id = azurerm_mssql_server.main.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }
} 