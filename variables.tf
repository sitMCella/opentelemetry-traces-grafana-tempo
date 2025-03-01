variable "location" {
  type        = string
  description = "(Required) The location of the Azure resources (e.g. westeurope)."
}

variable "location_abbreviation" {
  type        = string
  description = "(Required) The location abbreviation (e.g. weu)."
}

variable "environment" {
  type        = string
  description = "(Required) The environment name (e.g. test)."
}

variable "workload_name" {
  type        = string
  description = "(Required) The name of the workload."
}

variable "allowed_public_ip_address_ranges" {
  type        = list(string)
  description = "(Optional) The external IP address ranges allowed to access the Azure resources."
  default     = []
}

variable "allowed_public_ip_addresses" {
  type        = list(string)
  description = "(Optional) The external IP addresses allowed to access the Azure resources."
  default     = []
}
