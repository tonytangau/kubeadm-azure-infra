terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>2.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name = "k8s-rg"
  location = "southeastasia"
}

# resource "azurerm_network_security_group" "nsg" {
#   name                = "${local.prefix}-nsg"
#   location            = azurerm_resource_group.rg.location
#   resource_group_name = azurerm_resource_group.rg.name

#   security_rule {
#     name                       = "Port_80"
#     priority                   = 100
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }
# }

resource "azurerm_virtual_network" "vnet" {
  name                = "k8s-vnet"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "default" {
  name                 = "default"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_subnet" "jumpbox" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

module "master" {
    source   = "./modules/compute"
    type     = "master"
    rg       = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    subnetId = azurerm_subnet.default.id
}

module "node01" {
    source   = "./modules/compute"
    type     = "node01"
    rg       = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    subnetId = azurerm_subnet.default.id
}

module "node02" {
    source   = "./modules/compute"
    type     = "node02"
    rg       = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
    subnetId = azurerm_subnet.default.id
}