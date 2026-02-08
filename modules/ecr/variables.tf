variable "name" {
  description = "ECR repository name"
  type        = string
}

variable "image_tag_mutability" {
  description = "Image tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "scan_on_push" {
  description = "Enable image scanning on push"
  type        = bool
  default     = true
}

variable "kms_key_arn" {
  description = "KMS key ARN for ECR encryption (optional)"
  type        = string
  default     = null
}

variable "force_delete" {
  description = "Force delete repository with images"
  type        = bool
  default     = false
}

variable "lifecycle_policy" {
  description = "Lifecycle policy JSON (optional)"
  type        = string
  default     = null
}

variable "repository_policy" {
  description = "Repository policy JSON (optional)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}
