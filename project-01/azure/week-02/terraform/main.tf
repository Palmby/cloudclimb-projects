data "azurerm_resource_group" "cloud_project_resource_group" {
  name = "cloudprojects"
}

resource "tls_private_key" "linux_key"{
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "azurerm_linux_virtual_machine" "ubuntuVM" {
  name = "ubuntuVM"
  resource_group_name = data.azurerm_resource_group.cloud_project_resource_group.name 
  location = "eastus"
  size = "Standard_B1ls"
  admin_username = "locadmin"
  network_interface_ids = [resource.azurerm_network_interface.ubuntuVMNIC.id]

  admin_ssh_key {
    username = "locadmin"
    public_key = tls_private_key.linux_key.public_key_openssh
  }

  os_disk {
    caching = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}

resource "local_sensitive_file" "vm_key" {
  content         = tls_private_key.linux_key.private_key_openssh
  filename        = "${path.module}/.ssh/vm-linux-01"
  file_permission = "0600" # no-op on Windows — see below
}
