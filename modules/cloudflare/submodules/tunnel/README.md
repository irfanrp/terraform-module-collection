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
| `tunnel_ids` | Map of tunnel_name => tunnel id (when provider enabled). |

Notes

- The real Cloudflare provider types (`cloudflare_tunnel`, `cloudflare_tunnel_route`) are commented in `main.tf`. To enable them:
  1. Set `use_provider = true` on module call.
  2. Configure the `cloudflare` provider with appropriate credentials.
  3. Uncomment and adapt the provider blocks in this module.

Usage examples

Minimal tunnel (no routes)

```hcl
module "tunnel" {
  source = "../../modules/cloudflare/submodules/tunnel"

  account_id = var.account_id
  tunnels = {
    "my-tunnel" = { name = "my-tunnel" }
  }
  use_provider = false # set true to actually create resources
}
```

Tunnel with routes (create route objects pointing to private CIDRs)

```hcl
module "tunnel" {
  source = "../../modules/cloudflare/submodules/tunnel"

  account_id = var.account_id
  tunnels = {
    "my-tunnel" = {
      name   = "my-tunnel"
      routes = ["10.0.1.0/24", "10.0.2.0/24"]
    }
  }
  use_provider = true
}
```

Notes about provider & permissions

- The Cloudflare Zero Trust API requires an API token with permissions to manage tunnels and routes. Configure the `cloudflare` provider in your root module (example) with that token.
- Provide `account_id` for the Cloudflare account where tunnels should be created. This is required by the provider when creating tunnel/route resources.
- When `use_provider = false` the module uses placeholders and will not create real Cloudflare resources; this is useful for local validation and CI.
