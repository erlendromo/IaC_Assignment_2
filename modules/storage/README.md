# Storage Module

The purpose of this module is to provision a Storage account with blob storage (container).

## Resources

- `azurerm_storage_account`
- `azurerm_storage_container`

## Inputs (variables)

### Storage Account Variables

- `resource_group_name` String
- `location` String
- `storage_account_name` String
- `account_tier` String
- `account_kind` String
- `account_replication_type` String
- `https_traffic_only_enabled` Boolean
- `allow_nested_items_to_be_public` Boolean
- `public_network_access_enabled` Boolean
- `shared_access_key_enabled` Boolean
- `local_user_enabled` Boolean
- `min_tls_version` String

### Storage Container Variables

- `container_name` String
- `container_access_type` String

## Outputs

- `storage_account_name` String
- `storage_account_access_key` String
- `storage_blob_endpoint` String