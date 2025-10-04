variable "name" {
  description = "Logical name for the cloudfront distribution / resources"
  type        = string
}

variable "origin_bucket_regional_domain_name" {
  description = "The S3 bucket regional domain name to use as origin (e.g. module.bucket.bucket_regional_domain_name[\"key\"])."
  type        = string
}

variable "enabled" {
  description = "Whether to create the CloudFront distribution"
  type        = bool
  default     = true
}

variable "comment" {
  description = "Comment for CloudFront distribution"
  type        = string
  default     = ""
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "aliases" {
  description = "List of CNAMEs (alternate domain names) for the distribution"
  type        = list(string)
  default     = []
}

variable "certificate_arn" {
  description = "ACM certificate ARN for aliases (must be in us-east-1)"
  type        = string
  default     = ""
}

variable "default_ttl" {
  type    = number
  default = 86400
}

variable "min_ttl" {
  type    = number
  default = 0
}

variable "max_ttl" {
  type    = number
  default = 31536000
}

variable "viewer_protocol_policy" {
  description = "Viewer protocol policy for default cache behavior"
  type        = string
  default     = "redirect-to-https"
}

variable "create_oac" {
  description = "Create an Origin Access Control for the distribution (recommended)"
  type        = bool
  default     = true
}

variable "attach_bucket_policy" {
  description = "If true, create an S3 bucket policy that allows CloudFront distribution access only (requires target_bucket_arn and target_bucket_id)."
  type        = bool
  default     = false
}

variable "target_bucket_id" {
  description = "S3 bucket id (name) to attach policy to when attach_bucket_policy = true"
  type        = string
  default     = ""
}

variable "target_bucket_arn" {
  description = "S3 bucket arn to use in the policy resource when attach_bucket_policy = true"
  type        = string
  default     = ""
}

variable "source_account" {
  description = "Optional source account string to add to policy condition for cross-account scenarios"
  type        = string
  default     = ""
}
