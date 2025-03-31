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

variable "sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 