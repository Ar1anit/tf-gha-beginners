terraform {
  required_version = ">= 1.5.7"
  backend "azurerm" {
    resource_group_name  = "" # Replace with your resource group name
    storage_account_name = "" # Replace with your storage account name
    container_name       = "" # Replace with your container name
    key                  = "" # Replace with your state file name, IF NEEDED
  }
}

provider "azurerm" {
  features {}
  subscription_id = "" # Replace with your Azure subscription ID
}

data "azurerm_client_config" "current" {}

#Create Resource Group
resource "azurerm_resource_group" "example" {
  name     = "tf-gha-rg"
  location = "eastus"
}

#Create Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "tf-gha-vnet"
  address_space       = ["192.168.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.example.name
}

# Create Subnet
resource "azurerm_subnet" "subnet" {
  name                 = "subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["192.168.0.0/24"]
}