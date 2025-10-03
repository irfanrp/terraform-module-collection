variable "zone_id" {
  description = "Cloudflare zone ID"
  type        = string
}

variable "dns_records" {
  description = "Map of record_name => map with keys: type, value, optional ttl, optional proxied. Use empty map to create none."
  type        = map(any)
  default     = {}
}

variable "default_proxied" {
  description = "Default proxied value when not provided per-record"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Optional tags (meta)"
  type        = map(string)
  default     = {}
}

variable "use_provider" {
  description = "When true, create real cloudflare_record resources. Otherwise create null_resource placeholders."
  type        = bool
  default     = false
}
