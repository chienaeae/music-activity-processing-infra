variable "resource_prefix" {
  description = "Prefix for all resource names"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "admin_username" {
  description = "SQL Server administrator username"
  type        = string
}

variable "admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
}

variable "database_sku" {
  description = "SKU for the SQL Database"
  type        = string
  default     = "S0"
}

variable "environment" {
  description = "Deployment environment (test or prod)"
  type        = string
}

variable "db_subnet_id" {
  description = "ID of the database subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 