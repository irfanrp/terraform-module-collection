output "cloudflared_config_path" {
  value = local_file.cloudflared_config.filename
}

output "tunnel_ids" {
  description = "Map of tunnel key => tunnel id"
  value       = { for k, t in cloudflare_zero_trust_tunnel_cloudflared.this : k => t.id }
}

output "route_ids" {
  description = "Map of route key => route id"
  value       = { for k, r in cloudflare_zero_trust_tunnel_cloudflared_route.routes : k => r.id }
}
