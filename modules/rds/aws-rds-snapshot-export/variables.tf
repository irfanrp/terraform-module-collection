variable "bucket_name" {
  description = "Name of the S3 bucket to create for RDS snapshot export"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket when Terraform destroys it"
  type        = bool
  default     = false
}

variable "sse_algorithm" {
  description = "Server-side encryption algorithm for the bucket (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "versioning" {
  description = "Enable versioning on the S3 bucket"
  type        = bool
  default     = false
}

variable "lifecycle_enabled" {
  description = "Enable lifecycle expiration rule"
  type        = bool
  default     = false
}

variable "lifecycle_days" {
  description = "Days until objects expire (when lifecycle_enabled=true)"
  type        = number
  default     = 365
}

variable "tags" {
  description = "Map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "role_name" {
  description = "IAM role name for RDS snapshot export"
  type        = string
  default     = "rds-snapshot-export-role"
}

variable "kms_enabled" {
  description = "Whether KMS encryption is used and policy statements for KMS should be allowed"
  type        = bool
  default     = false
}

variable "kms_key_arn" {
  description = "Optional KMS key ARN to allow RDS to use for encryption"
  type        = string
  default     = ""
}
