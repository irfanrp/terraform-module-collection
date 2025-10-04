terraform {
  required_version = ">= 1.3.0"

  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = ">= 3.0, < 7.0"
    }
  }
}

# Provider configuration should be supplied by the root module (examples).