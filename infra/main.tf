terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
    
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}

# Generate a random string suffix to ensure unique resource names
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Local variables definition
locals {
  common_tags = {
    Project     = "User Activity Event Processing System"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
  
  resource_prefix = "event-proc-${var.environment}"
}

# Kubernetes Provider configuration - using AKS cluster credentials
provider "kubernetes" {
  host                   = module.aks.host
  client_certificate     = base64decode(module.aks.client_certificate)
  client_key             = base64decode(module.aks.client_key)
  cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
}

# Helm Provider configuration - using AKS cluster credentials
provider "helm" {
  kubernetes {
    host                   = module.aks.host
    client_certificate     = base64decode(module.aks.client_certificate)
    client_key             = base64decode(module.aks.client_key)
    cluster_ca_certificate = base64decode(module.aks.cluster_ca_certificate)
  }
} 