
# Linux VM Admin Password
variable "admin_password" {
  type        = string
  description = "Admin Password"
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

variable "container_image" {
  type        = string
  description = "the id and tag of the container image to use"
  default     = "aberner/microsave"
}

variable "container_docker_registry_url" {
  type        = string
  description = "the url of the container image to use"
  default     = "https://index.docker.io"
}

variable "scfile" {
  type        = string
  description = "the url of the container image to use"
  default     = "vm-setup/db/db-install.sh"
}

