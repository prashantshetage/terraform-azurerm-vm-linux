// Required Variables
variable "resource_group_name" {
  type        = string
  description = "(Required) The name of the Resource Group in which to create the Virtual Machine"
}

variable "location" {
  type        = string
  description = " (Required) The Azure location where the Linux Virtual Machine should exist"
}

variable "name" {
  type        = string
  description = "(Required) The name of the Linux Virtual Machine"
}

variable "admin_username" {
  type        = string
  description = "(Required) The username of the local administrator used for the Virtual Machine"
}

variable "network_interface_ids" {
  type        = list(string)
  description = "(Required) A list of Network Interface ID's which should be attached to this Virtual Machine"
}

variable "os_disk" {
  type = object({
    caching              = string
    storage_account_type = string
    disk_size_gb         = number
  })
  description = "(Required) OS disk properties for VM"
  default = {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = 30
  }
}

variable "size" {
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine"
}

variable "source_image_reference" {
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  description = "(Required) VM image to boot this VM"
  default = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}

variable "vm_count" {
  type        = number
  description = "(Optional) Number of VM's to be provisioned"
  default     = 1
}

variable "admin_ssh_key" {
  type = map(object({
    public_key = string
    username   = string
  }))
  description = "(Optional) One or more admin_ssh_key blocks as defined below"
}

variable "admin_password" {
  type        = string
  description = "(Optional) The Password which should be used for the local-administrator on this Virtual Machine"
  default = null
}

variable "disable_password_authentication" {
  type        = bool
  description = "(Optional) Should Password Authentication be disabled on this Virtual Machine?"
  default     = true
}




// Optional Variables
variable "additional_capabilities" {
  type = object({
    ultra_ssd_enabled = bool #(Optional) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine?
  })
  description = "(Optional) A additional_capabilities block"
  default = false
}

variable "allow_extension_operations" {
  type = bool
  description = "(Optional) Should Extension Operations be allowed on this Virtual Machine?"
  default = null
}

variable "availability_set_id" {
  type = string
  description = "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist"
  default = null
}

variable "boot_diagnostics" {
  type = object({
storage_account_uri = string #(Required) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics
  })
  description = "(Optional) A boot_diagnostics block as defined below"
  default = {
    storage_account_uri = null
  }
}

variable "computer_name" {
  type = string
  description = "(Optional) Specifies the Hostname which should be used for this Virtual Machin"
  default = null
}


variable "default_prefix" {
  type        = string
  description = "(Optional) Default prefix for virtual machine name"
  default     = "vm"
}

variable "custom_data" {
  type        = string
  description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine"
  default     = null
}

variable "dedicated_host_id" {
  type = string
  description = "(Optional) The ID of a Dedicated Host where this machine should be run on"
  default = null
}


variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Tags for deployment"
  default     = {}
}

variable "it_depends_on" {
  type        = any
  description = "(Optional) To define explicit dependencies if required"
  default     = null
}