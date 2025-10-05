# aws-rds-snapshot-export

This submodule provisions resources to support exporting Amazon RDS snapshots to S3.

Resources created:
- S3 bucket for export
- IAM role and policy granting RDS permission to write snapshot data to the bucket

Usage example

```hcl
module "rds_snapshot_export" {
  source = "../modules/rds/aws-rds-snapshot-export"

  bucket_name    = "my-rds-snapshot-exports-example"
  force_destroy  = false
  versioning     = true
  lifecycle_enabled = true
  lifecycle_days = 90
  tags = { Owner = "devops" }
}
```

Notes
- This module only creates the bucket and IAM role/policy. It does not start an RDS snapshot export task.
- If you use KMS encryption for the bucket, pass `kms_enabled = true` and provide `kms_key_arn`.
