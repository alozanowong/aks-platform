###############################################################################
# DIAGNOSTIC SETTINGS — AKS control plane logs -> shared Log Analytics
###############################################################################

resource "azurerm_monitor_diagnostic_setting" "aks" {
  name                       = "diag-${azurerm_kubernetes_cluster.aks.name}"
  target_resource_id         = azurerm_kubernetes_cluster.aks.id
  log_analytics_workspace_id = data.terraform_remote_state.landing_zone.outputs.log_analytics_workspace_id

  enabled_log {
    category = "kube-apiserver"
  }

  enabled_log {
    category = "kube-audit"
  }

  enabled_log {
    category = "kube-controller-manager"
  }

  enabled_log {
    category = "cluster-autoscaler"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
