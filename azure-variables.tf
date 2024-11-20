
# Linux VM Admin Password
variable "admin_password" {
  type        = string
  description = "Admin Password"
}

variable "unique_prefix" {
  type        = string
  description = "Your unique application name, set this value in you local terraform.tfvars  - it is used as a prefix for all resources"
}

variable "company_name" {
  type        = string
  description = "my fake company name, all lowercase"
  default     = "aquirksense"
}

# Location Resource Group
variable "rg_location" {
  type        = string
  description = "Location of Resource Group"
  default     = "Norway East"
}


# Ubuntu Linux Publisher used to build VMs
variable "ubuntu-linux-publisher" {
  type        = string
  description = "Ubuntu Linux Publisher used to build VMs"
  default     = "Canonical"
}

# Ubuntu Linux Offer used to build VMs
variable "ubuntu-linux-offer" {
  type        = string
  description = "Ubuntu Linux Offer used to build VMs"
  default     = "0001-com-ubuntu-server-jammy"
}

# Ubuntu Linux x.x SKU used to build VMs
variable "ubuntu-linux-sku" {
  type        = string
  description = "Ubuntu Linux Server SKU used to build VMs"
  default     = "22_04-lts"
}

