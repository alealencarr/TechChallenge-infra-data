# =============================================================================
# SQL Server Outputs
# =============================================================================

output "sql_server_fqdn" {
  description = "FQDN do SQL Server"
  value       = azurerm_mssql_server.sqlserver.fully_qualified_domain_name
}

# =============================================================================
# Connection Strings - SQL Databases
# =============================================================================

output "db_orders_connection_string" {
  description = "Connection string do database Orders/Products/Payments/Users (ms-orders)"
  value       = "Server=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db_orders.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "db_ingredients_connection_string" {
  description = "Connection string do database Ingredients (ms-ingredients)"
  value       = "Server=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db_ingredients.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

output "db_customers_connection_string" {
  description = "Connection string do database Customers (ms-customers)"
  value       = "Server=tcp:${azurerm_mssql_server.sqlserver.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.db_customers.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  sensitive   = true
}

# =============================================================================
# CosmosDB MongoDB Outputs (ms-categories)
# =============================================================================

output "cosmosdb_mongodb_connection_string" {
  description = "Connection string do CosmosDB MongoDB (ms-categories)"
  value       = azurerm_cosmosdb_account.mongodb.primary_mongodb_connection_string
  sensitive   = true
}

output "cosmosdb_mongodb_host" {
  description = "Host do CosmosDB MongoDB"
  value       = "${azurerm_cosmosdb_account.mongodb.name}.mongo.cosmos.azure.com"
}

output "cosmosdb_database_name" {
  description = "Nome do database MongoDB"
  value       = azurerm_cosmosdb_mongo_database.categories_db.name
}

# =============================================================================
# Storage Account Outputs
# =============================================================================

output "storage_account_name" {
  description = "Nome do Storage Account"
  value       = azurerm_storage_account.storage.name
}

output "storage_account_connection_string" {
  description = "Connection string do Storage Account"
  value       = azurerm_storage_account.storage.primary_connection_string
  sensitive   = true
}

output "storage_account_primary_blob_endpoint" {
  description = "Endpoint do blob storage"
  value       = azurerm_storage_account.storage.primary_blob_endpoint
}

output "storage_container_name" {
  description = "Nome do container de imagens"
  value       = azurerm_storage_container.images.name
}

# =============================================================================
# Database Names 
# =============================================================================

output "db_orders_name" {
  description = "Nome do database de Orders"
  value       = azurerm_mssql_database.db_orders.name
}

output "db_ingredients_name" {
  description = "Nome do database de Ingredients"
  value       = azurerm_mssql_database.db_ingredients.name
}

output "db_customers_name" {
  description = "Nome do database de Customers"
  value       = azurerm_mssql_database.db_customers.name
}
