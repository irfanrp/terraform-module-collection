# S3 module (wrapper)

This `modules/s3` folder contains a small wrapper module that delegates per-bucket
configuration to `modules/s3/submodules/bucket`. It provides a convenient,
map-driven interface to create multiple S3 buckets with production-friendly
defaults.

Main input
- `buckets` (map) — preferred interface. A map of key => bucket configuration
  objects. See the `submodules/bucket` README for available per-bucket options.
- Legacy compatibility: the module still accepts `bucket_name` (single) and
  `bucket_names` (list). When `buckets` is empty the wrapper converts legacy
  inputs into the `buckets` map. Legacy variables are deprecated and may be
  removed in a future major release.

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

CloudFront (OAC) integration

If you create a CloudFront distribution that serves content from an S3 bucket,
use the `modules/s3/submodules/cloudfront_oac` submodule. That submodule can
create an Origin Access Control (OAC) and — optionally — attach a restrictive
S3 bucket policy so that only the CloudFront distribution can get objects from
the bucket.

Example (CloudFront + attach bucket policy)

```hcl
module "bucket" {
  source = "../../modules/s3/submodules/bucket"
  key  = "example-oac"
  name = "example-oac-bucket-${terraform.workspace}"
}

module "cf" {
  source                         = "../../modules/s3/submodules/cloudfront_oac"
  name                           = "example-oac"
  origin_bucket_regional_domain_name = module.bucket.bucket_regional_domain_name
  create_oac                     = true
  attach_bucket_policy           = true
  target_bucket_id               = module.bucket.id
  target_bucket_arn              = module.bucket.arn
}
```

Notes & recommendations

- The module currently accepts `buckets` as a flexible type (`any`) to make
  migration from legacy variables easier.
- Bucket names are global across AWS — prefer unique suffixes (workspace/env) or
  pass explicit names to avoid conflicts.
- Keep your buckets private by default: avoid public ACLs/policies and enable
  Public Access Block unless you need website hosting or public assets.

Where to find more examples and docs

- Bucket submodule: `modules/s3/submodules/bucket/README.md`
- CloudFront OAC submodule: `modules/s3/submodules/cloudfront_oac/README.md`
- Verified examples: `examples/s3-basic`, `examples/s3-multi`, `examples/s3-cloudfront-oac`

Validate locally

```bash
cd examples/s3-cloudfront-oac
terraform init -backend=false
terraform validate
```