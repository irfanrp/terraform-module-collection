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

Usage examples

Single record

```hcl
module "dns" {
	source = "../../modules/cloudflare/submodules/dns"

	zone_id = var.zone_id
	dns_records = {
		"app.example.com" = {
			type   = "A"
			value  = "1.2.3.4"
			ttl    = 3600
			proxied = false
		}
	}
	use_provider = true
}
```

Multiple records

```hcl
module "dns" {
	source = "../../modules/cloudflare/submodules/dns"

	zone_id = var.zone_id
	dns_records = {
		"app.example.com" = { type = "A", value = "1.2.3.4", ttl = 3600 }
		"www.example.com" = { type = "CNAME", value = "app.example.com", ttl = 3600 }
	}
	use_provider = true
}
```

Notes

- Configure the `cloudflare` provider in the root module (examples), and ensure the API token has permissions to manage DNS for the provided `zone_id`.
- Set `use_provider = false` to use placeholders for testing without creating real Cloudflare resources.
