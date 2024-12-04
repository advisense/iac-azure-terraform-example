# recoveryservicesvault Module is used to create Recovery Services Vault to Protect the workloads
module "recovery_vault_01" {
  source = "./modules/recoveryservicesvault"

  recovery_vault_name = "az-mgmt-prod-noeast-bkp"
  resource_group_name = module.mgmt-resourcegroup.rg_name
  location            = module.mgmt-resourcegroup.rg_location
  sku                 = "Standard"
  soft_delete_enabled = true
}

# vm-windows Module is used to create Windows Desktop Virtual Machines
module "vm-jumpbox-01" {
  source                        = "./modules/vm-windows"
  virtual_machine_name          = "jumpserver01"
  nic_name                      = "jumpserver01-nic"
  location                      = module.mgmt-resourcegroup_01.rg_location
  resource_group_name           = module.mgmt-resourcegroup_01.rg_name
  ipconfig_name                 = "ipconfig1"
  subnet_id                     = module.hub-vnet.vnet_subnet_id[4]
  private_ip_address_allocation = "Dynamic"
  private_ip_address            = ""
  vm_size                       = "Standard_B2s"
  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true
  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  publisher       = "MicrosoftWindowsDesktop"
  offer           = "windows-11"
  sku             = "win11-23h2-pro"
  storage_version = "latest"

  os_disk_name      = "jumpserver01osdisk"
  caching           = "ReadWrite"
  create_option     = "FromImage"
  managed_disk_type = "Standard_LRS"

  admin_username = "${var.company_name}.admin"
  admin_password = var.admin_password

  provision_vm_agent = true
  depends_on         = [module.hub-vnet]
}