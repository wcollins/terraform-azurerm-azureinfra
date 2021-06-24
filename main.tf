resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = [var.address_space]
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

resource "azurerm_subnet" "subnet" {
  count                = length(var.subnet_names)
  name                 = var.subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = [var.subnet_prefixes[count.index]]
}

resource "azurerm_network_security_group" "nsg" {
    name                = "allow-all"
    location            = azurerm_resource_group.rg.location
    resource_group_name = azurerm_resource_group.rg.name

    security_rule {
        name                         = "allow-inbound"
        priority                     = 1001
        direction                    = "Inbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        destination_port_range       = "*"
        source_address_prefix        = "*"
        destination_address_prefix   = "*"
    }

    security_rule {
        name                         = "allow-outbound"
        priority                     = 1002
        direction                    = "Outbound"
        access                       = "Allow"
        protocol                     = "*"
        source_port_range            = "*"
        destination_port_range       = "*"
        source_address_prefix        = "*"
        destination_address_prefix   = "*"
    }

}

resource "azurerm_network_interface" "interface" {
    count                             = length(var.subnet_names)
    name                              = "vnic-${var.subnet_names[count.index]}"
    location                          = azurerm_resource_group.rg.location
    resource_group_name               = azurerm_resource_group.rg.name

    ip_configuration {
        name                          = "vnic-config"
        private_ip_address_allocation = "Dynamic"
        subnet_id                     = azurerm_subnet.subnet.*.id[count.index]
    }
}

resource "azurerm_network_interface_security_group_association" "assoc" {
    count                     = length(var.subnet_names)
    network_interface_id      = azurerm_network_interface.interface.*.id[count.index]
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "random_id" "id" {

  keepers = {
    resource_group = azurerm_resource_group.rg.name
  }

  byte_length = 8
}

resource "azurerm_storage_account" "storage" {
  name                     = random_id.id.hex
  account_tier             = "Standard"
  account_replication_type = "GRS"
  resource_group_name      = azurerm_resource_group.rg.name
  location                 = azurerm_resource_group.rg.location
}

resource "azurerm_linux_virtual_machine" "vm" {
    count                           = length(var.vm_names)
    name                            = var.vm_names[count.index]
    admin_username                  = var.ssh_user
    resource_group_name             = azurerm_resource_group.rg.name
    location                        = azurerm_resource_group.rg.location
    network_interface_ids           = [azurerm_network_interface.interface.*.id[count.index]]
    size                            = var.vm_size

    admin_ssh_key {
      username   = var.ssh_user
      public_key = var.ssh_key
    }

    os_disk {
        caching              = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = var.image_publisher
        offer     = var.image_offer
        sku       = var.image_sku
        version   = "latest"
    }

    disable_password_authentication = true

    boot_diagnostics {
        storage_account_uri = azurerm_storage_account.storage.primary_blob_endpoint
    }
}
