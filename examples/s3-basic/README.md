# S3 Basic Example

Creates a simple S3 bucket using the `modules/s3` module with versioning and server-side encryption enabled.

Usage:

```bash
cd examples/s3-basic
terraform init
terraform plan
terraform apply
```

Notes:
- The example creates a bucket named `tf-module-collection-example-bucket-<env_suffix>`.
- By default, access logging is disabled. To enable, provide `logging_enabled = true` and a `logging_target_bucket` that already exists.
- Ensure the `bucket_name` is globally unique when deploying.
