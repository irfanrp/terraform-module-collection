# S3 module (wrapper)

This `modules/s3` is a small wrapper that delegates per-bucket configuration to the
`modules/s3/submodules/bucket` submodule. It provides a convenient, map-driven
interface to create multiple buckets with sensible defaults.

Preferred input: `buckets` (map).

Quick example (multi-bucket)

```hcl
module "s3" {
  source = "../../modules/s3"

  buckets = {
    app_data = {
      name = "company-app-data-${terraform.workspace}"
      versioning_enabled = true
      server_side_encryption = { type = "SSE-S3" }
      tags = { env = "prod" }
    }

    public_assets = {
      name = "company-public-assets"
      acl  = "public-read"
      cors_rules = [ { allowed_methods = ["GET"], allowed_origins = ["*"] } ]
      tags = { env = "prod" }
    }
  }
}
```

Legacy compatibility

- The module still accepts the legacy `bucket_name` (single) and `bucket_names` (list) variables.
- When `buckets` is empty the wrapper will convert legacy inputs into the `buckets` map.
- Legacy variables are considered deprecated and may be removed in a future major release — migrate to the `buckets` map when convenient.

Where to find more examples

- Per-bucket options and examples: `modules/s3/submodules/bucket/README.md`
- Bucket policy examples: `modules/s3/submodules/policy/README.md`
- Example usages validated locally: `examples/s3-basic` and `examples/s3-multi`

Notes and recommendations

- `buckets` is intentionally flexible (the module accepts `any`) to make migration easier. If you want stricter validation we can switch to a typed `map(object({...}))` and update examples accordingly.
- Bucket names are globally unique across AWS — prefer predictable suffixes (workspace, env, etc.) or explicitly provide names.
- Be careful with public buckets; prefer `public_access_block` unless you explicitly need a website or public assets bucket.

How to validate examples locally

```bash
cd examples/s3-basic
terraform init -backend=false
terraform validate

cd ../s3-multi
terraform init -backend=false
terraform validate
```

License: MIT