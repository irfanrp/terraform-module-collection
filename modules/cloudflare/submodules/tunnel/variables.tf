variable "tunnels" {
  description = "Map of tunnel logical name => { name, ingress }"
  type = map(object({
    name    = string
    ingress = string
  }))
  default = {}
}

variable "tags" {
  description = "Optional tags/meta for tunnels"
  type        = map(string)
  default     = {}
}

variable "use_provider" {
  description = "When true, attempt to create real cloudflare_tunnel resources. If false, keep null_resource placeholders."
  type        = bool
  default     = false
}
