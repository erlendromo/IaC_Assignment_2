# Database Module

The purpose of this module is to provision a SQL-server, SQL-database and an extended auditing policy for the database.

## Resources

- `azurerm_mssql_server`
- `azurerm_mssql_database`
- `azurerm_mssql_database_extended_auditing_policy`

## Inputs (variables)

### SQL Server Variables

- `resource_group_name` String
- `locations` String
- `server_name` String
- `server_version` String
- `administrator_login` String
- `administrator_login_password` String
- `public_network_access_enabled` Boolean
- `minimum_tls_version` String

### SQL Database Variables

- `database_name` String
- `collation` String
- `license_type` String
- `max_size_gb` Number
- `read_scale_enabled` Boolean
- `sku_name` String
- `zone_redundant` Boolean
- `enclave_type` String
- `ledger_enabled` Boolean

### Extended Auditing Variables

- `retention_in_days` Number
- `storage_account_access_key` String
- `storage_account_access_key_is_secondary` Boolean
- `storage_endpoint` String

## Outputs

- `sql_database_username` String (sensitive)
- `sql_database_password` String (sensitive)