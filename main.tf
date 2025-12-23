resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

# Le VNet Hub (Centralise les services partagés/Firewall)
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-hub-central"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# Un Spoke de test (Sera ajouté automatiquement via Policy)
resource "azurerm_virtual_network" "spoke_test" {
  name                = "vnet-spoke-dynamic-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]

  tags = {
    Env = var.target_tag_value
  }
}