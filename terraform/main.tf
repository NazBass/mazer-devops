terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}


# Random suffix for globally unique storage account name
resource "random_string" "suffix" {
  length  = 8
  special = false
  upper   = false
}

# Resource Group
resource "azurerm_resource_group" "mazer" {
  name     = "rg-mazer-devops"
  location = "East US"
}


# Storage Account with static website hosting
resource "azurerm_storage_account" "mazer" {
  name                     = "stmazer${random_string.suffix.result}"
  resource_group_name      = azurerm_resource_group.mazer.name
  location                 = azurerm_resource_group.mazer.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  static_website {
    index_document     = "index.html"
    error_404_document = "error-404.html"
  }
}


# Output the website URL
output "static_website_url" {
  value = azurerm_storage_account.mazer.primary_web_endpoint
}

# Output storage account name (for Jenkins later)
output "storage_account_name" {
  value = azurerm_storage_account.mazer.name
}