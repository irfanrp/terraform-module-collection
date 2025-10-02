# S3 Module

🚧 **Coming Soon** - Amazon Simple Storage Service module

## Planned Features

- S3 Buckets
- Bucket policies
- Versioning
- Server-side encryption
- Lifecycle rules
- CORS configuration
- Public access block
- Notification configuration

## Usage (Preview)

Single bucket example:

```hcl
module "s3" {
  source = "./modules/s3"

  bucket_name = "my-app-bucket"

  versioning_enabled = true
  server_side_encryption_enabled = true
  sse_algorithm = "AES256"

  tags = {
    Environment = "dev"
  }
}
```

Multiple buckets example:

```hcl
module "s3_multiple" {
  source = "./modules/s3"
# S3 module

Terraform module to provision one or more S3 buckets with common production-friendly defaults and optional features such as versioning, server-side encryption, lifecycle rules, public access block, access logging and per-bucket policies.

This module focuses on safety-by-default (public access blocking, encryption enabled by default) while remaining flexible for advanced use-cases (custom policies, logging target, lifecycle rules).

## Features

- Create one or multiple buckets
- Versioning support
- Server-side encryption (AES256 or KMS)
- Lifecycle rules and transitions
- CORS rules
- Public access block configuration
- Optional server access logging
- Per-bucket custom policies
- Validation: fail early when configuration is missing or inconsistent

## Quick start — Examples

Single bucket:

```hcl
module "s3" {
  source = "./modules/s3"

  bucket_name = "my-app-bucket-${var.env_suffix}"

  versioning_enabled = true
  server_side_encryption_enabled = true
  sse_algorithm = "AES256"

  tags = {
    Environment = var.environment
  }
}
```

Multiple buckets:

```hcl
module "s3_multiple" {
  source = "./modules/s3"

  bucket_names = [
    "my-app-bucket-logs-${var.env_suffix}",
    "my-app-bucket-data-${var.env_suffix}",
  ]

  versioning_enabled = true
  server_side_encryption_enabled = true

  tags = {
    Environment = var.environment
  }
}
```

Attach custom policies per-bucket (optional):

```hcl
module "s3_with_policies" {
  source = "./modules/s3"

  bucket_names = ["my-app-bucket-data-${var.env_suffix}"]

  bucket_policies = {
    "my-app-bucket-data-${var.env_suffix}" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = "*",
          Action = ["s3:GetObject"],
          Resource = ["arn:aws:s3:::my-app-bucket-data-${var.env_suffix}/*"]
        }
      ]
    })
  }

  # Skip attaching policies (useful for review/CI) — default true
  attach_bucket_policies = true
}
```

## Inputs

| Name | Description | Type | Default |
|------|-------------|------:|:-------:|
| bucket_name | Single bucket name (legacy/compat) | string | "" |
| bucket_names | List of bucket names — create one bucket per name | list(string) | [] |
| acl | Canned ACL to attach (recommended: leave `null` to avoid deprecated acl argument) | string | null |
| force_destroy | Allow destroying bucket with objects | bool | false |
| versioning_enabled | Enable versioning | bool | true |
| server_side_encryption_enabled | Enable SSE | bool | true |
| sse_algorithm | SSE algorithm: "AES256" or "aws:kms" | string | "AES256" |
| kms_key_id | KMS key id when using `aws:kms` | string | null |
| lifecycle_rules | List of lifecycle rule objects | list(object) | [] |
| cors_rules | List of CORS rule objects | list(object) | [] |
| enable_public_access_block | Enable S3 public access block resource | bool | true |
| block_public_acls | Block public ACLs | bool | true |
| ignore_public_acls | Ignore public ACLs | bool | true |
| block_public_policy | Block public bucket policies | bool | true |
| restrict_public_buckets | Restrict public buckets | bool | true |
| logging_enabled | Enable server access logging | bool | false |
| logging_target_bucket | Target bucket for access logs (must exist) | string | null |
| logging_target_prefix | Prefix for access log objects | string | "logs/" |
| deny_insecure_transport | Add policy to deny non-TLS requests | bool | true |
| bucket_policies | Map(bucket_name => policy JSON string) to attach custom policies | map(string) | {} |
| attach_bucket_policies | Whether to attach `bucket_policies` to buckets (useful to disable during dry-run) | bool | true |
| tags | Tags to apply to created resources | map(string) | {} |

Notes:
- Use either `bucket_names` (preferred for multi-bucket) or `bucket_name` for single-bucket behavior.
- When possible avoid using `acl` (the S3 ACL model is deprecated in many use-cases). If you need to set an ACL the module will create an `aws_s3_bucket_acl` resource instead of using the deprecated `acl` argument on the bucket.

## Outputs

| Name | Description |
|------|-------------|
| bucket_ids | Map of bucket name -> bucket id |
| bucket_arns | Map of bucket name -> bucket ARN |
| bucket_domain_names | Map of bucket name -> bucket domain name |
| bucket_regional_domain_names | Map of bucket name -> regional domain name |

## Validation

- The module will fail early with a clear error if no bucket name is provided (neither `bucket_name` nor `bucket_names`).
- The module will also fail if `bucket_policies` contains keys that do not match any created bucket name — this avoids accidentally attaching policies to non-existent buckets.

## Recommendations & Notes

- Bucket names are global across AWS. Use unique suffixes (workspace, env_suffix, random_id) to avoid name collisions:

```hcl
locals { suffix = terraform.workspace }

bucket_names = ["my-app-data-${local.suffix}"]
```

- When enabling server access logging, ensure the `logging_target_bucket` exists and allows the source account to write logs.
- Policy JSON should be valid; the module expects `bucket_policies` values to be valid JSON strings (use `jsonencode()` from HCL to build them).
- For production, also consider:
  - Auto-scaling of lifecycle/transition rules for cost control
  - Cross-region replication (requires additional IAM and destination buckets)
  - Object lock for compliance (requires versioning)

## Troubleshooting

- If `terraform apply` fails with bucket name conflicts, add a unique suffix and re-run.
- If policy attachment fails, check that the policy JSON is valid and that `attach_bucket_policies` is true.

## License

MIT