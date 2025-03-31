variable "environment" {
  description = "Deployment environment (test or prod)"
  type        = string
  default     = "test"
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "resource_group_name" {
  description = "Name of the Azure resource group"
  type        = string
  default     = null
}

variable "aks_kubernetes_version" {
  description = "Kubernetes version for AKS cluster"
  type        = string
  default     = "1.32.0"
}

variable "aks_node_count" {
  description = "Number of nodes in the AKS cluster"
  type        = number
  default     = 2
}

variable "aks_vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "aks_auto_scaling_enabled" {
  description = "Enable auto-scaling for AKS cluster"
  type        = bool
  default     = true
}

variable "aks_auto_scaling_min_count" {
  description = "Minimum number of nodes when auto-scaling"
  type        = number
  default     = 1
}

variable "aks_auto_scaling_max_count" {
  description = "Maximum number of nodes when auto-scaling"
  type        = number
  default     = 5
}

variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "sql_server_admin_username" {
  description = "Admin username for SQL Server"
  type        = string
  default     = "sqladmin"
}

variable "sql_server_admin_password" {
  description = "Admin password for SQL Server"
  type        = string
  sensitive   = true
}

variable "sql_database_sku" {
  description = "SKU for SQL Database"
  type        = string
  default     = "S0"
}

variable "address_space" {
  description = "Address space for the VNet"
  type        = string
  default     = "10.0.0.0/16"
}

variable "aks_subnet_cidr" {
  description = "CIDR for AKS subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  description = "CIDR for database subnet"
  type        = string
  default     = "10.0.2.0/24"
} 