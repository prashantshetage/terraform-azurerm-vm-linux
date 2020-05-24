
// Create random id for resource naming
/*
resource "random_id" "vm-sa" {
  keepers = {
    vm_name = var.vm_name
  }

  byte_length = 6
}
*/


// Virtual Machine
resource "azurerm_linux_virtual_machine" "linux_vm" {
  count = var.vm_count
  name  = "${var.default_prefix}-${var.vm_name}-${count.index}"
  // TODO: computer_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password != "" ? var.admin_password : null
  disable_password_authentication = var.admin_password != "" ? false : true
  network_interface_ids           = var.network_interface_ids
  custom_data                     = var.custom_data != "" && fileexists("${path.module}/${var.custom_data}") ? base64encode(file("${path.module}/${var.custom_data}")) : null



  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key

    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }

  }

  os_disk {
    caching              = var.os_disk.caching
    storage_account_type = var.os_disk.storage_account_type
    disk_size_gb         = var.os_disk.disk_size_gb
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]
}