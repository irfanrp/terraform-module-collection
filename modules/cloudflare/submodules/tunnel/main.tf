# Placeholder implementation for Cloudflare Tunnels
# Replace with real provider resource `cloudflare_tunnel` when you wish to manage tunnels.

resource "null_resource" "tunnel" {
  for_each = var.tunnels

  triggers = {
    name    = each.value.name
    ingress = each.value.ingress
  }
}

# Real provider resources (optional). Enable by setting var.use_provider = true and configuring the cloudflare provider.
# Uncomment and adapt the blocks below if you want to manage Cloudflare Tunnels via the Cloudflare provider.

/*
resource "cloudflare_tunnel" "this" {
  for_each = var.use_provider ? var.tunnels : {}
  name     = each.value.name
  # provider-specific attributes here; this is an example placeholder
}

resource "cloudflare_tunnel_route" "route" {
  for_each = var.use_provider ? var.tunnels : {}
  tunnel_id = cloudflare_tunnel.this[each.key].id
  ingress = each.value.ingress
}
*/
