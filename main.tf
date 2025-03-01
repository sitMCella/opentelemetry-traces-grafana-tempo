locals {
  tags = {
    environment = var.environment
  }
}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-${var.workload_name}-${var.environment}-${var.location_abbreviation}-001"
  location = var.location
}

module "virtual_network" {
  source = "./modules/network"

  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  location_abbreviation = var.location_abbreviation
  environment           = var.environment
  tags                  = local.tags
}

module "storage_account" {
  source = "./modules/storage_account"

  resource_group_name                = azurerm_resource_group.resource_group.name
  location                           = var.location
  location_abbreviation              = var.location_abbreviation
  environment                        = var.environment
  allowed_public_ip_addresses        = var.allowed_public_ip_addresses
  allowed_virtual_network_subnet_ids = [module.virtual_network.subnet_aks_id]
  tags                               = local.tags
}

module "application_gateway" {
  source = "./modules/application_gateway"

  resource_group_name           = azurerm_resource_group.resource_group.name
  location                      = var.location
  location_abbreviation         = var.location_abbreviation
  environment                   = var.environment
  application_gateway_subnet_id = module.virtual_network.subnet_agw_id
  tags                          = local.tags
}

module "kubernetes_cluster" {
  source = "./modules/aks"

  resource_group_name   = azurerm_resource_group.resource_group.name
  location              = var.location
  location_abbreviation = var.location_abbreviation
  environment           = var.environment
  dns_prefix            = "${var.workload_name}${var.environment}${var.location_abbreviation}"
  vnet_subnet_id        = module.virtual_network.subnet_aks_id
  authorized_ip_ranges  = var.allowed_public_ip_address_ranges
  gateway_id            = module.application_gateway.application_gateway_id
  storage_account_id    = module.storage_account.storage_account_id
  tags                  = local.tags
}
