terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# 创建资源组用于存储tfstate
resource "azurerm_resource_group" "tfstate" {
  name     = var.resource_group_name
  location = var.location
  tags = {
    Environment = "Shared"
    ManagedBy   = "Terraform"
    Purpose     = "Terraform State Storage"
  }
}

# 创建存储账户用于存储tfstate
resource "azurerm_storage_account" "tfstate" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  blob_properties {
    versioning_enabled = true
  }

  tags = {
    Environment = "Shared"
    ManagedBy   = "Terraform"
    Purpose     = "Terraform State Storage"
  }
}

# 创建Blob容器用于存储tfstate文件
resource "azurerm_storage_container" "tfstate" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
} 