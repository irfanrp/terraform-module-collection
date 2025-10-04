variable "name" {
  description = "Bucket name (optional). If empty, the wrapper will generate a name using the key or prefix."
  type        = string
  default     = ""
}

variable "key" {
  description = "Map key for this bucket (used when called via for_each)"
  type        = string
}

variable "acl" {
  description = "Canned ACL for the bucket (optional)."
  type        = string
  default     = null
}

variable "force_destroy" {
  description = "Allow Terraform to destroy the bucket even if it contains objects"
  type        = bool
  default     = false
}

variable "versioning_enabled" {
  description = "Enable versioning for the bucket"
  type        = bool
  default     = true
}

variable "server_side_encryption" {
  description = "Server side encryption configuration (object). Example: { type = \"SSE-S3\" | \"SSE-KMS\", kms_key_id = string }"
  type = object({
    type       = string
    kms_key_id = optional(string)
  })
  default = { type = "SSE-S3" }
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules (passed through to aws_s3_bucket lifecycle)."
  type        = list(any)
  default     = []
}

variable "cors_rules" {
  description = "CORS rules passed through"
  type        = list(any)
  default     = []
}

variable "logging" {
  description = "Logging configuration: { target_bucket, target_prefix }"
  type        = object({ target_bucket = optional(string), target_prefix = optional(string) })
  default     = {}
}

variable "public_access_block" {
  description = "Public access block configuration (optional)"
  type = object({
    block_public_acls       = optional(bool)
    block_public_policy     = optional(bool)
    ignore_public_acls      = optional(bool)
    restrict_public_buckets = optional(bool)
  })
  default = {}
}

variable "tags" {
  description = "Tags for the bucket"
  type        = map(string)
  default     = {}
}
