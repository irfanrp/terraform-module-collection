variable "bucket_name" {
  description = "Name of the S3 bucket (for single-bucket usage). If you want to create multiple buckets, use `bucket_names` instead."
  type        = string
  default     = ""
}

variable "bucket_names" {
  description = "List of S3 bucket names to create. When provided, the module will create one bucket per name. If empty, `bucket_name` will be used (if set)."
  type        = list(string)
  default     = []
}

variable "buckets" {
  description = "Map of bucket_key => bucket configuration object. Preferred interface for multi-bucket usage. See module README for shape."
  type        = any
  default     = {}
}

variable "acl" {
  description = "Canned ACL for the bucket. Leave empty (null) to avoid setting an ACL on the bucket (recommended)."
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

variable "server_side_encryption_enabled" {
  description = "Enable server side encryption"
  type        = bool
  default     = true
}

variable "sse_algorithm" {
  description = "SSE algorithm to use (AES256 or aws:kms)"
  type        = string
  default     = "AES256"
}

variable "kms_key_id" {
  description = "KMS Key ID for SSE-KMS (optional)"
  type        = string
  default     = null
}

variable "lifecycle_rules" {
  description = "List of lifecycle rules"
  type = list(object({
    id                                     = optional(string)
    enabled                                = optional(bool)
    prefix                                 = optional(string)
    transitions                            = optional(list(object({ days = number, storage_class = string })), [])
    expiration                             = optional(object({ days = number }), null)
    abort_incomplete_multipart_upload_days = optional(number)
  }))
  default = []
}

variable "cors_rules" {
  description = "CORS rules for the bucket"
  type = list(object({
    allowed_methods = list(string)
    allowed_origins = list(string)
    allowed_headers = optional(list(string))
    expose_headers  = optional(list(string))
    max_age_seconds = optional(number)
  }))
  default = []
}

variable "enable_public_access_block" {
  description = "Enable S3 Public Access Block on the bucket"
  type        = bool
  default     = true
}

variable "block_public_acls" {
  description = "Block public ACLs"
  type        = bool
  default     = true
}

variable "ignore_public_acls" {
  description = "Ignore public ACLs"
  type        = bool
  default     = true
}

variable "block_public_policy" {
  description = "Block public bucket policies"
  type        = bool
  default     = true
}

variable "restrict_public_buckets" {
  description = "Restrict public buckets"
  type        = bool
  default     = true
}

variable "logging_enabled" {
  description = "Enable server access logging to another bucket"
  type        = bool
  default     = false
}

variable "logging_target_bucket" {
  description = "Target bucket for access logs (must exist)"
  type        = string
  default     = null
}

variable "logging_target_prefix" {
  description = "Prefix for access log objects"
  type        = string
  default     = "logs/"
}

variable "deny_insecure_transport" {
  description = "Add a bucket policy to deny requests that do not use TLS"
  type        = bool
  default     = true
}

variable "bucket_policies" {
  description = "Map of bucket name -> bucket policy (JSON string). If provided, the policy will be attached to the corresponding bucket. Use jsonencode() to build policies from HCL objects."
  type        = map(string)
  default     = {}
}

variable "attach_bucket_policies" {
  description = "Whether to attach user-provided bucket policies from `bucket_policies`. Set to false to skip attaching them."
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to the bucket"
  type        = map(string)
  default     = {}
}
