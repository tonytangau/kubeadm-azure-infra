resource "azurerm_public_ip" "jumpboxPip" {
    name                         = "jumpbox-pip"
    location                     = var.location
    resource_group_name          = var.rg
    allocation_method            = "Dynamic"
}

resource "azurerm_network_security_group" "nsg" {
  name                = "jumpbox-nsg"
  location                     = var.location
  resource_group_name          = var.rg

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface" "nic" {
    name                = "jumpbox-nic"
    resource_group_name = var.rg
    location            = var.location

    ip_configuration {
        name                          = "jumpbox-config"
        subnet_id                     = var.subnetId
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = azurerm_public_ip.jumpboxPip.id
    }
}

resource "azurerm_network_interface_security_group_association" "nsgLink" {
    network_interface_id      = azurerm_network_interface.nic.id
    network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "jumpbox-vm"
  resource_group_name             = var.rg
  location                        = var.location
  size                            = "Standard_D2as_v4"
  admin_username                  = "adminuser"
  admin_password                  = "samplePassword!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}