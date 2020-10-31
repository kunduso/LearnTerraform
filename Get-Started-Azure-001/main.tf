# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "2.34.0"
    }
  }
}

provider "azurerm" {
    version = "2.34.0"
    subscription_id = var.subscription_id
    client_id       = var.client_id
    client_secret   = var.client_secret
    tenant_id       = var.tenant_id
  features {}
}


resource "azurerm_resource_group" "t_rg" {
  name     = "Terraform-RG"
  location = "westus2"

  tags = {
    Environment = "Dev"
  }
}