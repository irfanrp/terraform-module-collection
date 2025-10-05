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

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}
