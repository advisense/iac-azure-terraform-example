# vnet defining the spoke 2 network
module "workstations-vnet" {
  source = "./modules/vnet"

  virtual_network_name          = "microsave-vnet-workstations"
  resource_group_name           = module.internal-workstation-resourcegroup.rg_name
  location                      = module.internal-workstation-resourcegroup.rg_location
  virtual_network_address_space = ["10.52.0.0/16"]
  subnet_names = {
    "microsave-vms-snet" = {
      subnet_name      = "microsave-wms-snet"
      address_prefixes = ["10.52.1.0/24"]
      route_table_name = ""
      snet_delegation  = ""
    }
  }
}

# one virtual desktop to be used by the company
module "desktop-windows-01" {
  source                        = "./modules/vm-windows"
  virtual_machine_name          = "microsavevm01"
  nic_name                      = "vm01-nic"
  location                      = module.internal-workstation-resourcegroup.rg_location
  resource_group_name           = module.internal-workstation-resourcegroup.rg_name
  ipconfig_name                 = "ipconfig1"
  subnet_id                     = module.workstations-vnet.vnet_subnet_id[0]
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.52.1.4"
  vm_size                       = "Standard_B2s"
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  publisher       = "MicrosoftWindowsDesktop"
  offer           = "windows-11"
  sku             = "win11-23h2-pro"
  storage_version = "latest"

  os_disk_name      = "wm01osdisk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"

  admin_username = "microsave.admin"
  admin_password = var.admin_password

  provision_vm_agent = true
  depends_on         = [module.workstations-vnet]
}


# a second virtual desktop server
module "desktop-windows-02" {
  source                        = "./modules/vm-windows"
  virtual_machine_name          = "microsavevm02"
  nic_name                      = "vm02-nic"
  location                      = module.internal-workstation-resourcegroup.rg_location
  resource_group_name           = module.internal-workstation-resourcegroup.rg_name
  ipconfig_name                 = "ipconfig2"
  subnet_id                     = module.workstations-vnet.vnet_subnet_id[0]
  private_ip_address_allocation = "Static"
  private_ip_address            = "10.52.1.5"
  vm_size                       = "Standard_B2s"
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  publisher       = "MicrosoftWindowsDesktop"
  offer           = "windows-11"
  sku             = "win11-23h2-pro"
  storage_version = "latest"

  os_disk_name      = "wm02osdisk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"

  admin_username = "microsave.admin"
  admin_password = var.admin_password

  provision_vm_agent = true
  depends_on         = [module.workstations-vnet]
}