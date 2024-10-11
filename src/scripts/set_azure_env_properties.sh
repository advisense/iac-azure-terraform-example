#!/bin/sh

export ARM_TENANT_ID=
export ARM_SUBSCRIPTION_ID=

RESOURCE_GROUP_NAME=StorageAccount-TerraformExample-State
STORAGE_ACCOUNT_NAME=iactfexampleacc


# set the subscription that you work on
az account set --subscription $ARM_SUBSCRIPTION_ID

ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv)
export ARM_ACCESS_KEY=$ACCOUNT_KEY
