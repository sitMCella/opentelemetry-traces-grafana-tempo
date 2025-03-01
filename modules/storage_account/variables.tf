variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group."
}

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

variable "allowed_public_ip_addresses" {
  type        = list(string)
  description = "(Required) List of public IP or IP ranges in CIDR Format."
}

variable "allowed_virtual_network_subnet_ids" {
  type        = list(string)
  description = "(Required) List of allowed subnet IDs."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The Tags for the Azure resources."
  default     = {}
}
