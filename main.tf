terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatetchungryale"
    container_name       = "tfstate"
    key                  = "infra-data.tfstate"
  }
}

provider "azurerm" {
  features {}
}

# --- Data Sources ---

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# =============================================================================
# SQL SERVER (Compartilhado entre microsserviços SQL)
# =============================================================================

resource "azurerm_mssql_server" "sqlserver" {
  name                         = var.sql_server_name
  resource_group_name          = data.azurerm_resource_group.rg.name 
  location                     = data.azurerm_resource_group.rg.location 
  version                      = "12.0"
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password
  
  minimum_tls_version           = "1.2"
  public_network_access_enabled = true
}

# --- Firewall: Permite serviços do Azure ---
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  name             = "AllowAllWindowsAzureIps"
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# =============================================================================
# SQL DATABASES (3 databases para microsserviços SQL)
# =============================================================================

# --- Database 1: Orders/Products/Payments/Users (ms-orders) ---
resource "azurerm_mssql_database" "db_orders" {
  name      = "Hungry_ProductsOrdersPaymentsUsers"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "S0"
  
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 250
  zone_redundant = false
}

# --- Database 2: Ingredients (ms-ingredients) ---
resource "azurerm_mssql_database" "db_ingredients" {
  name      = "Hungry_Ingredients"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "S0"
  
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 250
  zone_redundant = false
}

# --- Database 3: Customers (ms-customers) ---
resource "azurerm_mssql_database" "db_customers" {
  name      = "Hungry_Customers"
  server_id = azurerm_mssql_server.sqlserver.id
  sku_name  = "S0"
  
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  max_size_gb    = 250
  zone_redundant = false
}

# =============================================================================
# COSMOS DB (MongoDB API para ms-categories)
# =============================================================================

resource "azurerm_cosmosdb_account" "mongodb" {
  name                = var.cosmosdb_account_name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  offer_type          = "Standard"
  kind                = "MongoDB"
  
  # Habilita API do MongoDB
  mongo_server_version = "4.2"
  
  # Capacidade serverless (mais econômico para dev/teste)
  capabilities {
    name = "EnableServerless"
  }
  
  capabilities {
    name = "EnableMongo"
  }
  
  consistency_policy {
    consistency_level = "Session"
  }
  
  geo_location {
    location          = data.azurerm_resource_group.rg.location
    failover_priority = 0
  }
  
  # Segurança
  public_network_access_enabled     = true
  is_virtual_network_filter_enabled = false
  
  tags = {
    environment = "production"
    microservice = "ms-categories"
  }
}

# --- MongoDB Database para Categories ---
resource "azurerm_cosmosdb_mongo_database" "categories_db" {
  name                = "CategoriesDB"
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.mongodb.name
}

# --- Collection para Categories ---
resource "azurerm_cosmosdb_mongo_collection" "categories_collection" {
  name                = "categories"
  resource_group_name = data.azurerm_resource_group.rg.name
  account_name        = azurerm_cosmosdb_account.mongodb.name
  database_name       = azurerm_cosmosdb_mongo_database.categories_db.name
  
  index {
    keys   = ["_id"]
    unique = true
  }
  
  index {
    keys   = ["name"]
    unique = false
  }
}

# =============================================================================
# STORAGE ACCOUNT (Compartilhado - Imagens)
# =============================================================================

resource "azurerm_storage_account" "storage" {
  name                     = var.storage_account_name
  resource_group_name      = data.azurerm_resource_group.rg.name
  location                 = data.azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  
  min_tls_version                 = "TLS1_2"
  allow_nested_items_to_be_public = true
  
  blob_properties {
    delete_retention_policy {
      days = 7
    }
  }
}

resource "azurerm_storage_container" "images" {
  name                  = "imagens"
  storage_account_name  = azurerm_storage_account.storage.name
  container_access_type = "blob"
}