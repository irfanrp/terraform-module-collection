variable "account_id" {
  type        = string
  description = "Cloudflare Account ID (required when use_provider = true)"
  default     = ""
}

variable "zone_id" {
  type        = string
  description = "Cloudflare Zone ID"
  default     = ""
}

variable "tunnels" {
  description = "Map of tunnels. Each value: { name = string, secret = optional(string), routes = optional(list(string)) }"
  type = map(object({
    name   = string
    secret = optional(string)
    routes = optional(list(string))
  }))
  default = {}
}

variable "local_port" {
  type        = number
  description = "Local port for the app"
  default     = 8080
}

variable "use_provider" {
  type        = bool
  description = "When true, create real cloudflare tunnel resources"
  default     = true
}
