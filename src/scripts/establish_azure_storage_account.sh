#!/bin/bash

RESOURCE_GROUP_NAME=StorageAccount-TerraformExample-State
STORAGE_ACCOUNT_NAME=iactfexampleacc
CONTAINER_NAME=tfstate


# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location northeurope

# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob

# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME


ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY

echo ARM_ACCESS_KEY:  $ARM_ACCESS_KEY

#export ARM_ACCESS_KEY=$(az keyvault secret show --name iactfexample-statestorage-key --vault-name iactfexampleKeyVault --query value -o tsv)