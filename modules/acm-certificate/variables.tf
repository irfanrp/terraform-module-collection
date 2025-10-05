variable "domain_name" {
  description = "Primary domain name for the certificate (e.g. example.com)"
  type        = string
}

variable "subject_alternative_names" {
  description = "List of SANs to include on the certificate"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "ACM validation method (DNS or EMAIL). DNS is recommended for automation."
  type        = string
  default     = "DNS"
}

variable "hosted_zone_id" {
  description = "Optional Route53 hosted zone id to use for DNS validation. If not provided, module will look up zone by zone_name."
  type        = string
  default     = null
}

variable "zone_name" {
  description = "Optional Route53 zone name to look up when hosted_zone_id is not provided (e.g. example.com)."
  type        = string
  default     = null
}

variable "private_zone" {
  description = "When looking up zone by name, set to true to search private hosted zones"
  type        = bool
  default     = false
}

variable "create_route53_records" {
  description = "When true the module will create the DNS validation records in the hosted zone"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to apply to created resources"
  type        = map(string)
  default     = {}
}

variable "for_cloudfront" {
  description = "When true, request the certificate in us-east-1 (required for CloudFront)"
  type        = bool
  default     = false
}
