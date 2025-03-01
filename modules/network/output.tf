output "subnet_aks_id" {
  description = "The Resource ID of the Azure Kubernetes Service subnet"
  value       = azurerm_subnet.subnet_aks.id
}

output "subnet_agw_id" {
  description = "The Resource ID of the Application Gateway subnet"
  value       = azurerm_subnet.subnet_agw.id
}
