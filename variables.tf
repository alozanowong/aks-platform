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
