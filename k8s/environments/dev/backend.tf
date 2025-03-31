terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate"
    storage_account_name = "tfstatemusicactivity"
    container_name       = "tfstate"
    key                  = "k8s-dev.terraform.tfstate"
  }
}
