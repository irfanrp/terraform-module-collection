# Cloudflare Tunnel submodule (placeholder)

This submodule currently contains a placeholder implementation (a `null_resource`) so the wrapper can be used without requiring the Cloudflare provider's tunnel resource.

When you're ready to manage real Cloudflare Tunnels, replace the `null_resource` with `cloudflare_tunnel`/`cloudflare_tunnel_route` resources from the Cloudflare provider and return appropriate outputs (tunnel id, credentials, etc.).

Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `tunnels` | map(object) | `{}` | no | Map of logical name => { name, ingress } to define tunnels. |
| `tags` | map(string) | `{}` | no | Optional metadata/tags. |
| `use_provider` | bool | `false` | no | When true, attempt to create real cloudflare_tunnel resources (provider must be configured). |

Outputs

| Name | Description |
|------|-------------|
| `tunnel_triggers` | Map of tunnel_name => triggers (placeholder). |

Notes

- The real Cloudflare provider types (`cloudflare_tunnel`, `cloudflare_tunnel_route`) are commented in `main.tf`. To enable them:
  1. Set `use_provider = true` on module call.
  2. Configure the `cloudflare` provider with appropriate credentials.
  3. Uncomment and adapt the provider blocks in this module.
