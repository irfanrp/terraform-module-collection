# Cloudflare wrapper module

This is a small wrapper module that composes two focused Cloudflare submodules:

- `submodules/dns` — manage DNS records (Cloudflare `cloudflare_record`).
- `submodules/tunnel` — manage Cloudflare Tunnels (placeholder implementation; see notes).

Purpose

- Provide a single entrypoint for common Cloudflare patterns used by this repo (DNS + Tunnel).
- Keep per-concern logic in focused submodules so they are composable and testable.

Usage

```hcl
module "cloudflare" {
  source = "../../modules/cloudflare"

  # common
  zone_id = var.zone_id

  # DNS
  create_dns = true
  dns_records = {
    "app.example" = { value = "1.2.3.4", type = "A", ttl = 1, proxied = false }
  }

  # Tunnel
  create_tunnel = true
  tunnels = {
    "my-tunnel" = { name = "my-tunnel", ingress = "http://localhost:8080" }
  }
}
```

Notes

- When `use_provider = true` the modules will attempt to create real Cloudflare resources (DNS records, tunnels). Ensure you configure the `cloudflare` provider in the calling configuration and set provider booleans accordingly.

- If you plan to fully manage Cloudflare resources from this wrapper, set both `use_provider = true` and `use_tunnel_provider = true` on the wrapper module call. The example currently sets them to false and uses placeholders.

- The submodules include example implementations using the official Cloudflare provider resources where appropriate (DNS). The `tunnel` submodule includes a safe placeholder (a `null_resource`) so the module is usable without forcing a provider change — swap this for the real `cloudflare_tunnel` resource from the Cloudflare provider when you want to manage tunnels for real.
- You must configure the `cloudflare` provider in the calling configuration (API token/credentials). See the submodules' README files for more details.
