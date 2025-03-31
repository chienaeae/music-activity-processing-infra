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

variable "address_space" {
  description = "Address space for the virtual network"
  type        = string
}

variable "aks_subnet_cidr" {
  description = "CIDR for AKS subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "CIDR for database subnet"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 