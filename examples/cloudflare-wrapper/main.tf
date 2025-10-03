terraform { required_version = ">= 1.0" }

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

module "cf" {
  source     = "../../modules/cloudflare"
  create_dns = true
  zone_id    = var.zone_id
  dns_records = {
    "app.example" = { type = "A", value = "1.2.3.4", ttl = 1, proxied = false }
  }

  create_tunnel = true
  account_id    = var.account_id
  tunnels = {
    "my-tunnel" = { name = "my-tunnel", routes = ["10.0.1.0/24"] }
  }

  use_tunnel_provider = true
  use_dns_provider    = true
}

output "records" {
  value = module.cf.record_ids
}
output "tunnels" {
  value = module.cf.tunnel_ids
}
