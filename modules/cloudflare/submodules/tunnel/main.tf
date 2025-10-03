locals {
  # Normalize tunnels and ensure defaults
  tunnel_route_map = {
    for t_key, t in var.tunnels : t_key => {
      name   = t.name
      secret = try(t.secret, null)
      routes = try(t.routes, [])
    }
  }

  # Flatten tunnels -> routes into a single map keyed by "tunnel_key|idx"
  flattened_routes = merge([
    for t_key, t in local.tunnel_route_map :
    { for idx, route in t.routes : "${t_key}|${idx}" => {
      tunnel_key = t_key
      route_cidr = route
      }
    }
  ]...)
}

# Create Cloudflare Zero Trust tunnels (provider resource)
resource "cloudflare_zero_trust_tunnel_cloudflared" "this" {
  for_each   = var.use_provider ? local.tunnel_route_map : {}
  account_id = var.account_id
  name       = each.value.name
  # optional attribute; set to null when not provided
  tunnel_secret = try(each.value.secret, null)
}

# Create route resources per tunnel route
resource "cloudflare_zero_trust_tunnel_cloudflared_route" "routes" {
  for_each   = var.use_provider ? local.flattened_routes : {}
  account_id = var.account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.this[each.value.tunnel_key].id
  network    = each.value.route_cidr
}

locals {
  cloudflared_tunnel_ids = [for t in values(cloudflare_zero_trust_tunnel_cloudflared.this) : t.id]
  cloudflared_config     = <<EOF
tunnel: ${join(",", local.cloudflared_tunnel_ids)}
ingress:
  - service: http://localhost:${var.local_port}
EOF
}

resource "local_file" "cloudflared_config" {
  content  = local.cloudflared_config
  filename = "${path.module}/cloudflared-config.yaml"
}
