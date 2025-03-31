resource "azurerm_kubernetes_cluster" "main" {
  name                = "${var.resource_prefix}-aks"
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = "${var.resource_prefix}-aks"
  kubernetes_version  = var.kubernetes_version
  tags                = var.tags

  # Node pool configuration
  default_node_pool {
    name                = "default"
    vm_size             = var.vm_size
    node_count          = var.node_count
    enable_auto_scaling = var.auto_scaling_enabled
    min_count           = var.auto_scaling_enabled ? var.auto_scaling_min_count : null
    max_count           = var.auto_scaling_enabled ? var.auto_scaling_max_count : null
    vnet_subnet_id      = var.aks_subnet_id
    
    # Recommended to use system-assigned managed identity
    type                = "VirtualMachineScaleSets"
  }

  # Identity configuration - Use system-assigned managed identity
  identity {
    type = "SystemAssigned"
  }

  # Network configuration
  network_profile {
    network_plugin     = "azure"
    dns_service_ip     = "10.0.0.10"
    service_cidr       = "10.0.0.0/24"
  }

  # RBAC configuration
  role_based_access_control_enabled = true

  # Integrate Azure Monitor
  oms_agent {
    log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  }
}

# Create Log Analytics workspace for monitoring
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.resource_prefix}-log-analytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags
}

# Create Application Insights (optional)
resource "azurerm_application_insights" "main" {
  name                = "${var.resource_prefix}-app-insights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  retention_in_days   = 90
  tags                = var.tags
}

# Create AKS ACR pull role assignment - Allow AKS to pull images from ACR
resource "azurerm_role_assignment" "aks_acr_pull" {
  scope                = var.acr_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_kubernetes_cluster.main.kubelet_identity[0].object_id
} 