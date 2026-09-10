###############################################################################
# REMOTE STATE — tenant-landing-zone
# Reads network + governance outputs published by the Azure Landing Zone
# instead of duplicating them here. This is cross-repo Terraform composition:
# aks-platform has no module dependency on tenant-landing-zone, only a
# read-only reference to its published state outputs.
###############################################################################

data "terraform_remote_state" "landing_zone" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-tfstate-msp-prod"
    storage_account_name = "stmspterraformstate"
    container_name       = "tfstate"
    key                  = "client-a/prod/terraform.tfstate"
  }
}
