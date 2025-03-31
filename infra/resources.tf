# Create resource group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name != null ? var.resource_group_name : "${local.resource_prefix}-rg"
  location = var.location
  tags     = local.common_tags
}

# Deploy network module
module "network" {
  source              = "./modules/network"
  resource_prefix     = local.resource_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  address_space       = var.address_space
  aks_subnet_cidr     = var.aks_subnet_cidr
  db_subnet_cidr      = var.db_subnet_cidr
  tags                = local.common_tags
}

# Deploy ACR module
module "acr" {
  source              = "./modules/acr"
  resource_prefix     = local.resource_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  sku                 = var.acr_sku
  tags                = local.common_tags
}

# Deploy AKS module
module "aks" {
  source                = "./modules/aks"
  resource_prefix       = local.resource_prefix
  resource_group_name   = azurerm_resource_group.main.name
  location              = var.location
  kubernetes_version    = var.aks_kubernetes_version
  node_count            = var.aks_node_count
  vm_size               = var.aks_vm_size
  auto_scaling_enabled  = var.aks_auto_scaling_enabled
  auto_scaling_min_count = var.aks_auto_scaling_min_count
  auto_scaling_max_count = var.aks_auto_scaling_max_count
  aks_subnet_id         = module.network.aks_subnet_id
  acr_id                = module.acr.acr_id
  tags                  = local.common_tags
}

# Deploy database module
module "database" {
  source              = "./modules/database"
  resource_prefix     = local.resource_prefix
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location
  admin_username      = var.sql_server_admin_username
  admin_password      = var.sql_server_admin_password
  database_sku        = var.sql_database_sku
  environment         = var.environment
  db_subnet_id        = module.network.db_subnet_id
  tags                = local.common_tags
} 