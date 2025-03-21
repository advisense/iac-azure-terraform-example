package policies

# Enforce HTTPS for Azure Storage Accounts
deny[msg] {
    resource := input.resource
    resource.type == "azurerm_storage_account"
    not resource.properties.enable_https_traffic_only
    msg = sprintf("Storage account '%s' must have HTTPS traffic only enabled.", [resource.name])
}
# Enforce minimum TLS version for Azure Storage Accounts
deny[msg] {
    resource := input.resource
    resource.type == "azurerm_storage_account"
    resource.properties.minimum_tls_version != "TLS1_2"
    msg = sprintf("Storage account '%s' must have a minimum TLS version of TLS1_2.", [resource.name])
}

# Enforce that public access is disabled for Azure Storage Accounts
deny[msg] {
    resource := input.resource
    resource.type == "azurerm_storage_account"
    resource.properties.allow_blob_public_access == true
    msg = sprintf("Storage account '%s' must not allow public access to blobs.", [resource.name])
}