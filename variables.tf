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

variable "source_image_reference" {
  type = object({
    publisher = string #(Optional) Specifies the publisher of the image used to create the virtual machines
    offer     = string #(Optional) Specifies the offer of the image used to create the virtual machines
    sku       = string #(Optional) Specifies the SKU of the image used to create the virtual machines
    version   = string #(Optional) Specifies the version of the image used to create the virtual machines
  })
  description = "(Required) VM image to boot this VM"
  default     = null
}

variable "source_image_id" {
  type        = string
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from"
  default     = null
}

variable "os_disk" {
  type = object({
    caching                   = string #(Required) The Type of Caching which should be used for the Internal OS Disk
    storage_account_type      = string #(Required) The Type of Storage Account which should back this the Internal OS Disk
    disk_size_gb              = number #(Optional) The Size of the Internal OS Disk in GB
    disk_encryption_set_id    = string #(Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk
    name                      = string #(Optional) The name which should be used for the Internal OS Disk. Changing this forces a new resource to be created
    write_accelerator_enabled = bool   #(Optional) Should Write Accelerator be Enabled for this OS Disk?
  })
  description = "(Required) OS disk properties for VM"
}

variable "size" {
  type        = string
  description = "(Required) The SKU which should be used for this Virtual Machine"
}

variable "admin_ssh_key" {
  type = map(object({
    public_key = string
    username   = string
  }))
  description = "(Optional) One or more admin_ssh_key blocks as defined below"
}


// Optional Variables
variable "admin_password" {
  type        = string
  description = "(Optional) The Password which should be used for the local-administrator on this Virtual Machine"
  default     = null
}

variable "disable_password_authentication" {
  type        = bool
  description = "(Optional) Should Password Authentication be disabled on this Virtual Machine?"
  default     = true
}

variable "computer_name" {
  type        = string
  description = "(Optional) Specifies the Hostname which should be used for this Virtual Machin"
  default     = null
}

variable "custom_data" {
  type        = string
  description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine"
  default     = null
}

variable "identity" {
  type = object({
    type         = string       #(Required) The type of Managed Identity which should be assigned to the Linux Virtual Machine
    identity_ids = list(string) #(Optional) A list of User Managed Identity ID's which should be assigned to the Linux Virtual Machine.
  })
  description = "(Optional) Identities to be assigned to VM"
  default     = null
}

variable "additional_capabilities" {
  type = object({
    ultra_ssd_enabled = bool #(Optional) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine?
  })
  description = "(Optional) A additional_capabilities block"
  default = {
    ultra_ssd_enabled = false
  }
}

variable "allow_extension_operations" {
  type        = bool
  description = "(Optional) Should Extension Operations be allowed on this Virtual Machine?"
  default     = null
}



# Moniroting and Diagnostics
variable "boot_diagnostics" {
  type = object({
    storage_account_uri = string #(Required) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics
  })
  description = "(Optional) A boot_diagnostics block as defined below"
  default = {
    storage_account_uri = null
  }
}
variable "provision_vm_agent" {
  type        = bool
  description = "(Optional) Should the Azure VM Agent be provisioned on this Virtual Machine?"
  default     = true
}

# Performance and Availability
variable "dedicated_host_id" {
  type        = string
  description = "(Optional) The ID of a Dedicated Host where this machine should be run on"
  default     = null
}
variable "proximity_placement_group_id" {
  type        = string
  description = "(Optional) The ID of the Proximity Placement Group which the Virtual Machine should be assigned to"
  default     = null
}
variable "availability_set_id" {
  type        = string
  description = "(Optional) Specifies the ID of the Availability Set in which the Virtual Machine should exist"
  default     = null
}
variable "zone" {
  type        = string
  description = "(Optional) The Zone in which this Virtual Machine should be created"
  default     = null
}

# Spot VMs
variable "priority" {
  type        = string
  description = "(Optional) Specifies the priority of this Virtual Machine"
  default     = null
}
variable "eviction_policy" {
  type        = string
  description = "(Optional) Specifies what should happen when the Virtual Machine is evicted for price reasons when using a Spot instance"
  default     = null
}
variable "max_bid_price" {
  type        = number
  description = "(Optional) The maximum price you're willing to pay for this Virtual Machine"
  default     = null
}

# Marketplace Plan
variable "plan" {
  type = object({
    name      = string #(Required) Specifies the Name of the Marketplace Image this Virtual Machine should be created from
    product   = string #(Required) Specifies the Product of the Marketplace Image this Virtual Machine should be created from
    publisher = string #(Required) Specifies the Publisher of the Marketplace Image this Virtual Machine should be created from
  })
  description = "(Optional) Plan block for Marketplace product"
  default = {
    name      = null
    product   = null
    publisher = null
  }
}


# Security
variable "secret" {
  type = map(object({
    certificate = map(object({
      url = string #(Required) The Secret URL of a Key Vault Certificate
    }))
    key_vault_id = string #(Required) The ID of the Key Vault from which all Secrets should be sourced"
  }))
  description = "(Optional) Manage secure deployments of certificates to Linux Virtual Machine"
  default     = {}
}

variable "vm_prefix" {
  type        = string
  description = "(Required) Prefix for the vm name"
  default     = ""
}

variable "vm_suffix" {
  type        = string
  description = "(Optional) Suffix for the vm name"
  default     = ""
}

variable "resource_tags" {
  type        = map(string)
  description = "(Optional) Tags for the resources"
  default     = {}
}

variable "deployment_tags" {
  type        = map(string)
  description = "(Optional) Additional Tags for the deployment"
  default     = {}
}

variable "it_depends_on" {
  type        = any
  description = "(Optional) To define explicit dependencies if required"
  default     = null
}

variable "timeout" {
  type        = string
  description = "(Optional) Timeout"
  default     = "45m"
}


// Local Values
locals {
  timeout_duration = var.timeout
  vm_name          = "${var.vm_prefix}${var.name}${var.vm_suffix}"
}
