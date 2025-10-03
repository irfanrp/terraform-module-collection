// Wrapper that delegates to dns and tunnel submodules

variable "zone_id" {
  description = "Cloudflare zone id"
  type        = string
  default     = null
}

variable "create_dns" {
  description = "Create DNS records via submodule"
  type        = bool
  default     = false
}

variable "dns_records" {
  description = "Map of dns records to create"
  type        = map(any)
  default     = {}
}

variable "default_proxied" {
  description = "Default proxied value for DNS records"
  type        = bool
  default     = false
}

variable "create_tunnel" {
  description = "Create tunnels via submodule"
  type        = bool
  default     = false
}

variable "tunnels" {
  description = "Map of tunnels to create"
  type        = map(any)
  default     = {}
}

variable "use_tunnel_provider" {
  description = "When true, submodule will attempt to use the Cloudflare provider's tunnel resources"
  type        = bool
  default     = false
}

module "dns" {
  source          = "./submodules/dns"
  count           = var.create_dns ? 1 : 0
  zone_id         = var.zone_id
  dns_records     = var.dns_records
  default_proxied = var.default_proxied
}

module "tunnel" {
  source       = "./submodules/tunnel"
  count        = var.create_tunnel ? 1 : 0
  tunnels      = var.tunnels
  use_provider = var.use_tunnel_provider
}
