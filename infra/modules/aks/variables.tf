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

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
}

variable "node_count" {
  description = "Node count for the AKS cluster"
  type        = number
  default     = 2
}

variable "vm_size" {
  description = "VM size for AKS nodes"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "auto_scaling_enabled" {
  description = "Enable auto-scaling for AKS"
  type        = bool
  default     = true
}

variable "auto_scaling_min_count" {
  description = "Minimum node count for auto-scaling"
  type        = number
  default     = 1
}

variable "auto_scaling_max_count" {
  description = "Maximum node count for auto-scaling"
  type        = number
  default     = 5
}

variable "aks_subnet_id" {
  description = "Subnet ID for AKS"
  type        = string
}

variable "acr_id" {
  description = "ACR ID for AKS to pull images from"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
} 