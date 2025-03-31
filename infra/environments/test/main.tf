module "event_processing_test" {
  source = "../../"
  
  # Test environment configuration
  environment                = "test"
  location                   = "eastus"
  resource_group_name        = "event-proc-test-rg"
  
  # AKS configuration - Test environment uses smaller resources
  aks_kubernetes_version     = "1.32.0"
  aks_node_count             = 1
  aks_vm_size                = "Standard_B2s"
  aks_auto_scaling_enabled   = true
  aks_auto_scaling_min_count = 1
  aks_auto_scaling_max_count = 3
  
  # ACR configuration
  acr_sku                    = "Basic"
  
  # Database configuration
  sql_server_admin_username  = "sqladmin"
  sql_server_admin_password  = var.sql_admin_password
  sql_database_sku           = "Basic"
  
  # Network configuration
  address_space              = "10.1.0.0/16"
  aks_subnet_cidr            = "10.1.1.0/24"
  db_subnet_cidr             = "10.1.2.0/24"
} 