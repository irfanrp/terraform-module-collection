variable "zone_id" {
  type    = string
  default = ""
}

variable "cloudflare_api_token" {
  description = "Cloudflare API token for provider authentication (or set CLOUDFLARE_API_TOKEN env var)."
  type        = string
  default     = ""
}

variable "account_id" {
  description = "Cloudflare account id used for Zero Trust tunnels"
  type        = string
  default     = ""
}
