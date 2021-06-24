# Azure - Base Infrastructure Module
Terraform module that creates base infrastructure in [Microsoft Azure](https://azure.microsoft.com/en-us/) for testing [Alkira Network Cloud](https://alkira.com). This module is ideal for deploying a flexible network infrastructure with Azure's low-cost, general-purpose Standard_B1s virtual machines in each subnet for testing. Virtual machines are provisioned without public IP addresses. This presents a simple and completely private environment, ideal for testing integration to Alkira's Cloud Services Exchange (CSX).

## What It Does
- Create a [Virtual Network (VNet)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-overview)
- Build one or more [Subnets](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-network-manage-subnet) (provided as a list)
- Build a [Virtual Machine](https://azure.microsoft.com/en-us/services/virtual-machines/) running [Ubuntu](https://ubuntu.com/) per subnet
- Push provided _public key_ data to each virtual machine
- Build and apply a [Network Security Group (NSG)](https://docs.microsoft.com/en-us/azure/virtual-network/network-security-groups-overview) setup with **_any-to-any_** for both **_ingress_** and **_egress_** traffic
> The Network Security Group is set to _allow-all_ for inbound and outbound traffic because Alkira's policy manages this functionality across all clouds; This would normally be a bad practice and not recommended otherwise

## Usage
```hcl
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

module "azure-infra" {
  source  = "wcollins/azureinfra/azurerm"

  location            = "eastus2"
  resource_group_name = "rg-azure-east"
  vnet_name           = "vnet-azure-east"
  address_space       = "10.2.0.0/16"
  subnet_names        = ["subnet-01", "subnet-02", "subnet-03"]
  subnet_prefixes     = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
  vm_names            = ["vm-azure-east-01", "vm-azure-east-02", "vm-azure-east-03"]
  ssh_key             = var.ssh_key
}
```