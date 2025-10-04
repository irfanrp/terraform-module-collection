Bucket submodule

This submodule creates a single S3 bucket and optional configurations: versioning, server-side encryption, lifecycle rules, CORS and public access block.

Usage (wrapper will typically call this via for_each):

```hcl
module "bucket" {
  source = "../../modules/s3/submodules/bucket"
  for_each = var.buckets

  key = each.key
  name = try(each.value.name, "")
  acl  = try(each.value.acl, null)
  force_destroy = try(each.value.force_destroy, false)
  tags = try(each.value.tags, {})
}
```

Notes
- This module is intentionally minimal — some features (logging, replication) can be added at wrapper level or moved to own submodules.
