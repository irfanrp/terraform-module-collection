variable "identifier" {
  description = "RDS identifier (base name)"
  type        = string
}

variable "engine" {
  description = "Database engine (postgres, mysql, mariadb)"
  type        = string
}

variable "engine_version" {
  description = "Optional engine version"
  type        = string
  default     = null
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
  default     = 20
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = null
}

variable "username" {
  description = "Master username"
  type        = string
  default     = null
}

variable "password" {
  description = "Master password"
  type        = string
  default     = null
}

variable "vpc_security_group_ids" {
  description = "Security groups to attach to the DB"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "DB subnet group name"
  type        = string
  default     = null
}

variable "db_subnet_ids" {
  description = "List of subnet IDs for DB subnet group (optional)"
  type        = list(string)
  default     = []
}

variable "publicly_accessible" {
  description = "Whether DB instance is publicly accessible"
  type        = bool
  default     = false
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "backup_retention_period" {
  description = "Backup retention days"
  type        = number
  default     = 7
}

variable "backup_window" {
  description = "Preferred backup window"
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Preferred maintenance window"
  type        = string
  default     = null
}

variable "create_proxy" {
  description = "Enable RDS Proxy"
  type        = bool
  default     = false
}

variable "proxy_vpc_subnet_ids" {
  description = "VPC subnet IDs for RDS Proxy (required if create_proxy is true)"
  type        = list(string)
  default     = []
}

variable "proxy_vpc_security_group_ids" {
  description = "Security group IDs for RDS Proxy"
  type        = list(string)
  default     = []
}

variable "proxy_max_connections" {
  description = "Maximum number of client connections to proxy"
  type        = number
  default     = 100
}

variable "proxy_max_idle_connections" {
  description = "Maximum number of idle connections to DB"
  type        = number
  default     = 50
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
