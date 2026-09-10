###############################################################################
# WORKLOAD IDENTITY — example federated credentials
# Demonstrates pod-level Azure auth with no static secrets: one user-assigned
# identity + federated credential per workload that needs Azure API access,
# bound to the cluster's OIDC issuer.
###############################################################################

resource "azurerm_user_assigned_identity" "workload" {
  for_each = var.workload_identities

  name                = "id-${each.key}-${var.client_name}-${var.environment}"
  resource_group_name = azurerm_resource_group.aks.name
  location            = azurerm_resource_group.aks.location
  tags                = local.mandatory_tags
}

resource "azurerm_federated_identity_credential" "workload" {
  for_each = var.workload_identities

  name                = each.key
  resource_group_name = azurerm_resource_group.aks.name
  parent_id           = azurerm_user_assigned_identity.workload[each.key].id
  audience            = ["api://AzureADTokenExchange"]
  issuer              = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  subject             = "system:serviceaccount:${each.value.namespace}:${each.value.service_account_name}"
}
