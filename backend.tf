terraform {
  backend "azurerm" {
    resource_group_name  = "rg-tfstate-msp-prod"
    storage_account_name = "stmspterraformstate"
    container_name       = "tfstate"
    key                  = "client-a/prod/aks-platform.tfstate"
  }
}
