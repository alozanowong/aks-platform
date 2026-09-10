variable "client_name" {
  type        = string
  description = "Short client identifier used in resource naming (e.g. client-a)."
  default     = "client-a"
}

variable "environment" {
  type        = string
  description = "Deployment environment (e.g. prod, dev)."
  default     = "prod"
}

variable "location" {
  type        = string
  description = "Azure region for the AKS resource group and cluster."
  default     = "eastus2"
}

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the AKS control plane. Leave null to use the current AKS default."
  default     = null
}

variable "sku_tier" {
  type        = string
  description = "AKS control plane SKU tier (Free or Standard). Standard adds an uptime SLA."
  default     = "Free"
}

variable "network_policy" {
  type        = string
  description = "Network policy engine used with Azure CNI Overlay (azure or calico)."
  default     = "azure"
}

variable "system_vm_size" {
  type        = string
  description = "VM size for the system node pool."
  default     = "Standard_D2s_v5"
}

variable "system_node_min_count" {
  type        = number
  description = "Minimum node count for the system node pool autoscaler."
  default     = 1
}

variable "system_node_max_count" {
  type        = number
  description = "Maximum node count for the system node pool autoscaler."
  default     = 3
}

variable "user_vm_size" {
  type        = string
  description = "VM size for the user node pool."
  default     = "Standard_D4s_v5"
}

variable "user_node_min_count" {
  type        = number
  description = "Minimum node count for the user node pool autoscaler."
  default     = 1
}

variable "user_node_max_count" {
  type        = number
  description = "Maximum node count for the user node pool autoscaler."
  default     = 5
}

variable "aks_admin_group_object_ids" {
  type        = list(string)
  description = "Entra ID group object IDs granted break-glass cluster-admin access."
  default     = []
}

variable "aks_rbac_role_assignments" {
  type = map(object({
    principal_id = string
    role         = string # One of: "Cluster Admin", "Admin", "Reader", "Writer"
  }))
  description = "Entra ID principals granted Azure RBAC access to the AKS cluster, keyed by an arbitrary label."
  default     = {}
}
