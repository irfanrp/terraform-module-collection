# CloudFront OAC submodule

Creates a CloudFront distribution with an S3 origin and an optional Origin
Access Control (OAC). This submodule also supports an optional, restrictive
S3 bucket policy that limits GetObject access to the created CloudFront
distribution only.

## When to use
- Use this submodule when you want CloudFront in front of a private S3 bucket
  (no website hosting). The distribution will use OAC to sign requests to S3.

## Inputs

| Name | Type | Default | Description |
|------|------|---------|-------------|
| name | string | n/a | Logical name for resources (used in resource names) |
| origin_bucket_regional_domain_name | string | n/a | Regional domain name of the S3 bucket to use as origin (e.g. module.bucket.bucket_regional_domain_name["key"]) |
| enabled | bool | true | Create the CloudFront distribution |
| create_oac | bool | true | Create an Origin Access Control (recommended) |
| attach_bucket_policy | bool | false | When true, create a restrictive S3 bucket policy that allows only this distribution to GetObject |
| target_bucket_id | string | "" | S3 bucket id/name (required when attach_bucket_policy = true) |
| target_bucket_arn | string | "" | S3 bucket ARN (required when attach_bucket_policy = true) |
| source_account | string | "" | Optional SourceAccount used in policy (for cross-account scenarios) |
| aliases | list(string) | [] | CNAMEs/alternate names for the distribution |
| certificate_arn | string | "" | ACM certificate ARN for aliases (must be in us-east-1) |
| viewer_protocol_policy | string | "redirect-to-https" | Viewer protocol policy for default cache behavior |
| price_class | string | "PriceClass_100" | CloudFront price class |

## Outputs

| Name | Description |
|------|-------------|
| distribution_id | CloudFront distribution ID (empty string when not created) |
| distribution_arn | CloudFront distribution ARN (empty string when not created) |

## Basic usage

```hcl
module "bucket" {
  source = "../../modules/s3/submodules/bucket"
  key  = "example-oac"
  name = "example-oac-bucket-${terraform.workspace}"
}

module "cf" {
  source = "../../modules/s3/submodules/cloudfront_oac"
  name                           = "example-oac"
  origin_bucket_regional_domain_name = module.bucket.bucket_regional_domain_name
  create_oac                     = true
}
```

## Usage with restrictive bucket policy (recommended for private buckets)

This example creates the CloudFront distribution and also attaches a bucket
policy so only the created distribution may GetObject from the bucket.

```hcl
module "bucket" {
  source = "../../modules/s3/submodules/bucket"
  key  = "example-oac"
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

## Notes & requirements

- If you add `aliases` (custom domain names) make sure the ACM certificate is
  in the `us-east-1` region (CloudFront requirement).
- When using `attach_bucket_policy = true` in cross-account setups you may need
  to set `source_account` so the bucket policy includes `AWS:SourceAccount` in
  addition to `AWS:SourceArn`.
- This module creates a policy that allows the CloudFront service principal to
  `s3:GetObject` only when the request originates from the created
  distribution ARN. Make sure there are no other public ACLs/policies on the
  target bucket.

