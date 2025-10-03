module "dns" {
  source          = "./submodules/dns"
  zone_id         = var.zone_id
  dns_records     = var.dns_records
  default_proxied = false
  use_provider    = var.use_dns_provider
}

module "tunnel" {
  source       = "./submodules/tunnel"
  account_id   = var.account_id
  zone_id      = var.zone_id
  tunnels      = var.tunnels
  local_port   = var.local_port
  use_provider = var.use_tunnel_provider
}

output "record_ids" {
  value = try(module.dns.record_ids, {})
}

output "tunnel_ids" {
  value = try(module.tunnel.tunnel_ids, {})
}
