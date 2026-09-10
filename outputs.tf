output "aks_cluster_id" {
  value       = azurerm_kubernetes_cluster.aks.id
  description = "Resource ID of the AKS cluster."
}

output "aks_cluster_name" {
  value       = azurerm_kubernetes_cluster.aks.name
  description = "Name of the AKS cluster."
}

output "aks_oidc_issuer_url" {
  value       = azurerm_kubernetes_cluster.aks.oidc_issuer_url
  description = "OIDC issuer URL used for Workload Identity federation."
}

output "aks_kube_config_command" {
  value       = "az aks get-credentials --resource-group ${azurerm_resource_group.aks.name} --name ${azurerm_kubernetes_cluster.aks.name} --overwrite-existing"
  description = "Azure CLI command to fetch cluster credentials (Entra ID + Azure RBAC -- no static kubeconfig secrets)."
}

output "workload_identity_client_ids" {
  value       = { for k, v in azurerm_user_assigned_identity.workload : k => v.client_id }
  description = "Client IDs of the provisioned workload identities, keyed by workload name. Reference in pod annotations (azure.workload.identity/client-id)."
}
