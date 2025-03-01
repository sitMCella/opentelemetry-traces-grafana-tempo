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

variable "dns_prefix" {
  type        = string
  description = "(Required) DNS prefix specified when creating the managed cluster."
}

variable "vnet_subnet_id" {
  type        = string
  description = "(Required) The ID of a Subnet where the Kubernetes Node Pool should exist."
}

variable "authorized_ip_ranges" {
  type        = list(string)
  description = "(Required) Authorized IP address ranges to allow access to API server."
}

variable "gateway_id" {
  type        = string
  description = "(Required) The ID of the Application Gateway."
}

variable "storage_account_id" {
  type        = string
  description = "(Required) The ID of the Storage Account."
}

variable "tags" {
  type        = map(string)
  description = "(Optional) The Tags for the Azure resources."
  default     = {}
}
