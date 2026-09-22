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

  #use ssh-keygen -t rsa -b 4096 to generate the file, then move it to the ssh location you specify in your variable
  admin_ssh_key {
    username = "locadmin"
    public_key = file(var.ssh_location)
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



##########################Use if you want to generate the ssh key on terraform creation#################################
  #add this to the admin ssh key in the azurerm_azure_linux_vm#
  #admin_ssh_key {
  #  username = "locadmin"
  #  public_key = tls_private_key.linux_key.public_key_openssh
  #}

#generates an ssh key
#resource "tls_private_key" "linux_key"{
#  algorithm = "RSA"
#  rsa_bits = 4096
#}

#Creates key and moves it folder called .ssh
#
#resource "local_sensitive_file" "vm_key" {
#  content         = tls_private_key.linux_key.private_key_openssh
#  filename        = "${path.module}/.ssh/vm-linux-01"
#}
#You will need to grant read only permissions to yourself to use ssh key