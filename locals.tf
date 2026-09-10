locals {
  mandatory_tags = {
    client      = var.client_name
    environment = var.environment
    managed_by  = "terraform"
    project     = "aks-platform"
  }
}
