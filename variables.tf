variable "resource_group_name" {
  type        = string
  description = "Nome do resource group onde os recursos serão criados"
  default     = "rg-tchungry-prod"
}

variable "location" {
  type        = string
  description = "Região do Azure"
  default     = "Brazil South"
}

# =============================================================================
# SQL Server
# =============================================================================

variable "sql_server_name" {
  type        = string
  description = "Nome do SQL Server"
  default     = "sql-tchungry-hnaia0"
}

variable "sql_admin_login" {
  type        = string
  description = "Username do admin do SQL Server"
  default     = "admintchungry"
}

variable "sql_admin_password" {
  type        = string
  description = "Senha do admin do SQL Server"
  sensitive   = true
  # IMPORTANTE: Não deixar default em produção!
  # Passar via: terraform apply -var="sql_admin_password=SUA_SENHA"
  # Ou via GitHub Secret no pipeline
}

# =============================================================================
# CosmosDB (MongoDB)
# =============================================================================

variable "cosmosdb_account_name" {
  type        = string
  description = "Nome da conta CosmosDB (MongoDB API)"
  default     = "cosmos-tchungry-mongodb"
}

# =============================================================================
# Storage Account
# =============================================================================

variable "storage_account_name" {
  type        = string
  description = "Nome do Storage Account"
  default     = "strgtchungryprod"
}
