terraform {
  required_version = ">= 1.5.7"
  backend "azurerm" {
    resource_group_name  = "tf-gha-beginners"
    storage_account_name = "tfghabeginners"
    container_name       = "gha-tfstate"
    key                  = "tfstate"
  }
}
 
provider "azurerm" {
  features {}
}
 
data "azurerm_client_config" "current" {}
 
#Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = "tf-gha-rg"
  location = "germanywest"
}
 
#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-gha-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = "germanywest"
  resource_group_name = azurerm_resource_group.example.name
}
 
# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}