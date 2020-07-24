
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
resource "azurerm_linux_virtual_machine" "vm" {
  name                            = local.vm_name
  resource_group_name             = var.resource_group_name
  location                        = var.location
  size                            = var.size
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.admin_password != null ? false : true
  network_interface_ids           = var.network_interface_ids
  # TODO: Custom data over SCM
  custom_data   = var.custom_data != "null" && fileexists("${path.module}/${var.custom_data}") ? base64encode(file("${path.module}/${var.custom_data}")) : null
  computer_name = var.computer_name



  dynamic "admin_ssh_key" {
    for_each = var.admin_ssh_key

    content {
      username   = admin_ssh_key.value.username
      public_key = admin_ssh_key.value.public_key
    }

  }

  os_disk {
    caching                   = var.os_disk.caching
    storage_account_type      = var.os_disk.storage_account_type
    disk_size_gb              = var.os_disk.disk_size_gb
    disk_encryption_set_id    = var.os_disk.disk_encryption_set_id
    name                      = var.os_disk.name
    write_accelerator_enabled = var.os_disk.write_accelerator_enabled
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  /* identity {
    type = var.identity.type
    identity_ids = var.identity.identity_ids
  } */

  source_image_id            = var.source_image_id
  
  additional_capabilities {
    ultra_ssd_enabled = var.additional_capabilities.ultra_ssd_enabled
  }

  allow_extension_operations = var.allow_extension_operations

  # Moniroting and Diagnostics
  /* boot_diagnostics {
    storage_account_uri = var.boot_diagnostics.storage_account_uri
  } */

  # Performance and Availability
  dedicated_host_id            = var.dedicated_host_id
  proximity_placement_group_id = var.proximity_placement_group_id
  availability_set_id          = var.availability_set_id
  zone                         = var.zone

  # Spot VMs
  priority        = var.priority
  eviction_policy = var.eviction_policy
  max_bid_price   = var.max_bid_price

  # Marketplace Plan
  /* plan {
    name      = var.plan.name
    product   = var.plan.product
    publisher = var.plan.publisher
  } */


  # Security
  dynamic "secret" {
    for_each = var.secret
    content {
      dynamic "certificate" {
        for_each = secret.value.certificate
        content {
          url = certificate.value.url
        }
      }
      key_vault_id = secret.value.key_vault_id
    }
  }

  tags       = merge(var.resource_tags, var.deployment_tags)
  depends_on = [var.it_depends_on]

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

  timeouts {
    create = local.timeout_duration
    delete = local.timeout_duration
  }
}