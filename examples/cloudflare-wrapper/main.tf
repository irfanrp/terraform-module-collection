terraform { required_version = ">= 1.0" }

provider "cloudflare" {
  # configure with env var or token
}

module "cf" {
  source     = "../../modules/cloudflare"
  create_dns = true
  zone_id    = var.zone_id
  dns_records = {
    "app.example" = { type = "A", value = "1.2.3.4", ttl = 1, proxied = false }
  }

  create_tunnel = true
  tunnels = {
    "my-tunnel" = { name = "my-tunnel", ingress = "http://localhost:8080" }
  }

  use_tunnel_provider = false
}

output "records" { value = try(module.cf[0].record_ids, null) }
output "tunnels" { value = try(module.cf[0].tunnel_triggers, null) }
