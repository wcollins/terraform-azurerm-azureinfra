variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  description = "Azure - region"
  type        = string
}

variable "vnet_name" {
  description = "VNet name"
  type        = string
}

variable "address_space" {
  description = "VNet address space"
  type        = string
}

variable "vm_names" {
  description = "List of VM names"
  type        = list(string)
}

variable "subnet_names" {
  description = "List of subnet names"
  type        = list(string)
}

variable "subnet_prefixes" {
  description = "List of subnet prefixes"
  type        = list(string)
}

variable "vm_size" {
  description = "Default size"
  type        = string
  default     = "Standard_B1s"
}

variable "image_publisher" {
  description = "Default publisher"
  type        = string
  default     = "Canonical"
}

variable "image_offer" {
  description = "Default offer"
  type        = string
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "Default SKU"
  type        = string
  default     = "18.04-LTS"
}

variable "ssh_user" {
  description = "VM default user"
  type        = string
  default     = "ubuntu"
}

variable "ssh_key" {
  description = "Public key data"
  type        = string
}

variable "tags" {
  description = "The tags to associate with your network and subnets."
  type        = map(string)

  default = {
    environment = "non-production"
  }
}