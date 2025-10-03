variable "account_id" {
  description = "Cloudflare Account ID"
  type        = string
}

variable "zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
}

variable "local_port" {
  description = "Port aplikasi lokal"
  type        = number
  default     = 8080
}

variable "create_dns" {
  description = "Whether to create DNS records"
  type        = bool
  default     = false
}

variable "dns_records" {
  description = "Map of DNS records to create"
  type        = map(any)
  default     = {}
}

variable "create_tunnel" {
  description = "Whether to create tunnels"
  type        = bool
  default     = false
}

variable "tunnels" {
  description = "Map of tunnels passed to the tunnel submodule"
  type        = map(any)
  default     = {}
}

variable "use_tunnel_provider" {
  description = "When true, create real provider-backed tunnels"
  type        = bool
  default     = false
}

variable "use_dns_provider" {
  description = "When true, create real provider-backed DNS records"
  type        = bool
  default     = false
}
