terraform {
  required_version = ">= 0.12.29"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.46.0"
    }
  }
}
