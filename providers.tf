terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>4.4.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "StorageAccount-TerraformExample-State" # Can be passed via `-backend-config=`"resource_group_name=<resource group name>"` in the `init` command.
    storage_account_name = "iactfexampleacc"                       # Can be passed via `-backend-config=`"storage_account_name=<storage account name>"` in the `init` command.
    container_name       = "tfstate"                               # Can be passed via `-backend-config=`"container_name=<container name>"` in the `init` command.
    key                  = "terraform.tfstate"                     # Can be passed via `-backend-config=`"key=<blob key name>"` in the `init` command.
    use_oidc             = true
  }
}

# 2. Configure the AzureRM Provider
provider "azurerm" {
  # set tenant_id as a env through the env ARM_TENANT_ID= 
  # set subscription_id through the env ARM_SUBSCRIPTION_ID = 
  # The AzureRM Provider supports authenticating using via the Azure CLI, a Managed Identity
  # and a Service Principal. More information on the authentication methods supported by
  # the AzureRM Provider can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure

  # The features block allows changing the behaviour of the Azure Provider, more
  # information can be found here:
  # https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/features-block
  use_oidc = true
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
}
