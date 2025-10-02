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

  bucket_names = [
    "my-app-bucket-logs",
    "my-app-bucket-data",
  ]

  versioning_enabled = true
  server_side_encryption_enabled = true
  sse_algorithm = "AES256"

  tags = {
    Environment = "dev"
  }
}
```

Attach custom policies per-bucket:

```hcl
module "s3_with_policies" {
  source = "./modules/s3"

  bucket_names = ["my-app-bucket-data", "my-app-bucket-logs"]

  bucket_policies = {
    "my-app-bucket-data" = jsonencode({
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Principal = "*",
          Action = ["s3:GetObject"],
          Resource = ["arn:aws:s3:::my-app-bucket-data/*"]
        }
      ]
    })
  }
}

You can control whether to actually attach the provided policies using the `attach_bucket_policies` flag (default: `true`). Set it to `false` to skip attaching policies while keeping the policy definitions available for review or other tooling.
```

Stay tuned for updates!