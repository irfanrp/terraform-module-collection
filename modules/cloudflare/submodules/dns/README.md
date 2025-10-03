# Cloudflare DNS submodule

Create DNS records using the Cloudflare provider's `cloudflare_record` resource.

Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `zone_id` | string | n/a | yes | Cloudflare zone ID. |
| `dns_records` | map(object) | `{}` | no | Map of record_name => { type, value, ttl, proxied } to create. |

Outputs

| Name | Description |
|------|-------------|
| `record_ids` | Map of record_name => Cloudflare record id. |
| `record_names` | Map of record_name => name created. |
