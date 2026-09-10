###############################################################################
# RESOURCE GROUP — AKS platform
###############################################################################

resource "azurerm_resource_group" "aks" {
  name     = "rg-aks-${var.client_name}-${var.environment}"
  location = var.location
  tags     = local.mandatory_tags
}

###############################################################################
# AKS CLUSTER
# Azure CNI Overlay networking (avoids VNet IP exhaustion vs. plain Azure CNI)
# Entra ID + Azure RBAC for cluster authorization
# OIDC issuer + Workload Identity enabled for pod-level Azure auth
###############################################################################

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks-${var.client_name}-${var.environment}"
  location            = azurerm_resource_group.aks.location
  resource_group_name = azurerm_resource_group.aks.name
  dns_prefix          = "aks-${var.client_name}-${var.environment}"
  kubernetes_version  = var.kubernetes_version
  sku_tier            = var.sku_tier

  default_node_pool {
    name                         = "system"
    vm_size                      = var.system_vm_size
    vnet_subnet_id               = data.terraform_remote_state.landing_zone.outputs.workload_subnet_id
    only_critical_addons_enabled = true
    enable_auto_scaling          = true
    node_count                   = var.system_node_min_count
    min_count                    = var.system_node_min_count
    max_count                    = var.system_node_max_count
  }

  identity {
    type = "SystemAssigned"
  }

  network_profile {
    network_plugin      = "azure"
    network_plugin_mode = "overlay"
    network_policy      = var.network_policy
    load_balancer_sku   = "standard"
  }

  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = true
    admin_group_object_ids = var.aks_admin_group_object_ids
  }

  oidc_issuer_enabled       = true
  workload_identity_enabled = true

  tags = local.mandatory_tags

  lifecycle {
    ignore_changes = [
      default_node_pool[0].node_count,
    ]
  }
}

###############################################################################
# USER NODE POOL
###############################################################################

resource "azurerm_kubernetes_cluster_node_pool" "user" {
  name                  = "user"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = var.user_vm_size
  vnet_subnet_id        = data.terraform_remote_state.landing_zone.outputs.workload_subnet_id
  enable_auto_scaling   = true
  node_count            = var.user_node_min_count
  min_count             = var.user_node_min_count
  max_count             = var.user_node_max_count
  mode                  = "User"
  tags                  = local.mandatory_tags

  lifecycle {
    ignore_changes = [
      node_count,
    ]
  }
}

###############################################################################
# AZURE RBAC — cluster access
# Grants Entra ID principals Azure RBAC roles scoped to this cluster instead
# of static kubeconfig credentials. Populate via terraform.tfvars per client.
###############################################################################

resource "azurerm_role_assignment" "aks_rbac" {
  for_each = var.aks_rbac_role_assignments

  scope                = azurerm_kubernetes_cluster.aks.id
  role_definition_name = "Azure Kubernetes Service RBAC ${each.value.role}"
  principal_id         = each.value.principal_id
}
