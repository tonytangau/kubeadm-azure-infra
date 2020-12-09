resource "azurerm_network_interface" "nic" {
  name                = "${var.type}-nic"
  resource_group_name = var.rg
  location            = var.location

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                            = "${var.type}-vm"
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