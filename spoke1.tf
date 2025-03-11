
# vnet defining the network segment for spoke 1
module "internalapp-vnet" {
  source = "./modules/vnet"

  virtual_network_name          = "microsave-vnet-internalapp"
  resource_group_name           = module.internalapp-resourcegroup.rg_name
  location                      = module.internalapp-resourcegroup.rg_location
  virtual_network_address_space = ["10.51.0.0/16"]
  subnet_names = {
    "microsave-prod-web-snet" = {
      subnet_name      = "microsave-web-snet"
      address_prefixes = ["10.51.1.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    },
    "microsave-prod-db-snet" = {
      subnet_name      = "microsave-db-snet"
      address_prefixes = ["10.51.2.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
  }
} 

# a windows based servers used to run the internal app service
module "app-windows-01" {
  source                        = "./modules/vm-windows"
  virtual_machine_name          = "win-app01"
  nic_name                      = "win-app01-nic"
  location                      = module.internalapp-resourcegroup.rg_location
  resource_group_name           = module.internalapp-resourcegroup.rg_name
  ipconfig_name                 = "ipconfig1"
  subnet_id                     = module.internalapp-vnet.vnet_subnet_id[1]
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.51.1.4"
  vm_size                       = "Standard_A1_v2"
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  publisher       = "MicrosoftWindowsServer"
  offer           = "WindowsServer"
  sku             = "2019-Datacenter"
  storage_version = "latest"

  os_disk_name      = "winapp01osdisk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"

  admin_username = "microsave.admin"
  admin_password = var.admin_password

  provision_vm_agent = true
  depends_on         = [module.internalapp-vnet]
}

# a linux server to hosed the database for the internal service
module "vm-linux-01" {
  source                        = "./modules/vm-linux"
  nic_name                      = "linux-db01-nic"
  location                      = module.internalapp-resourcegroup.rg_location
  resource_group_name           = module.internalapp-resourcegroup.rg_name
  ipconfig_name                 = "ipconfig1"
  subnet_id                     = module.internalapp-vnet.vnet_subnet_id[0]
  private_ip_address_allocation = "Dynamic"
  private_ip_address            = ""
  # if you wish to have static - Change Dynamic to Static - Fill in Private IP
  virtual_machine_name = "linuxdb01"
  vm_size              = "Standard_A1_v2"
  # size                           = "Standard_D8s_v3"

  publisher       = "Canonical"
  offer           = "0001-com-ubuntu-server-jammy"
  sku             = "22_04-lts"
  storage_version = "latest"

  os_disk_name      = "linuxdb01osdisk"
  caching           = "ReadWrite"
  managed_disk_type = "Standard_LRS"
  disk_size_gb      = "255"
  # if you need larger disk  
  # disk_size_gb                     = "511"

  admin_username                  = "microsave.admin"
  admin_password                  = var.admin_password
  disable_password_authentication = false
  depends_on                      = [module.internalapp-vnet]
}

resource "azurerm_virtual_machine_extension" "linuxdb01-ext" {
  name                 = "linuxdb01-ext"
  virtual_machine_id   = module.vm-linux-01.id
  publisher            = "Microsoft.Azure.Extensions"
  type                 = "CustomScript"
  type_handler_version = "2.0"

  settings = <<SETTINGS
 {
  "script": "${base64encode(file(var.scfile))}"
 }
SETTINGS
}

