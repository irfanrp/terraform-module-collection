CloudFront OAC submodule

Creates an Origin Access Control (OAC) and a CloudFront distribution that uses an S3 origin.

Inputs (important)
- `name` – logical name for the distribution
- `origin_bucket_regional_domain_name` – the S3 bucket regional domain name (e.g. `module.bucket.bucket_regional_domain_name["key"]`)
- `create_oac` – bool, create OAC (recommended)

Optional bucket-policy wiring
- `attach_bucket_policy` (bool) — when true the module will create an S3 bucket policy that allows this CloudFront distribution to GetObject from the target bucket only.
- `target_bucket_id` (string) — bucket name/id to attach policy to when `attach_bucket_policy = true`.
- `target_bucket_arn` (string) — bucket ARN used in the policy resource.
- `source_account` (string, optional) — when set will add `AWS:SourceAccount` to the policy condition (useful for cross-account setups).

Quick example (attach policy)

```hcl
module "bucket" {
  source = "../../modules/s3/submodules/bucket"
  key = "example-oac"
  name = "example-oac-bucket-${terraform.workspace}"
}

module "cf" {
  source = "../../modules/s3/submodules/cloudfront_oac"
  name = "example-oac"
  origin_bucket_regional_domain_name = module.bucket.bucket_regional_domain_name
  create_oac = true
  attach_bucket_policy = true
  target_bucket_id = module.bucket.id
  target_bucket_arn = module.bucket.arn
}
```
