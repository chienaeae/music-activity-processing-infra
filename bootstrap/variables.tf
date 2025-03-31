variable "resource_group_name" {
  description = "The name of the resource group for Terraform state storage"
  type        = string
  default     = "rg-tfstate"
}

variable "location" {
  description = "The Azure region where resources will be created"
  type        = string
  default     = "eastus"
}

variable "storage_account_name" {
  description = "存储账户名称（必须全局唯一，只能包含小写字母和数字，长度3-24个字符）"
  type        = string
  default     = "tfstatemusicactivity"
}

variable "container_name" {
  description = "The name of the blob container for Terraform state files"
  type        = string
  default     = "tfstate"
} 