S3 + CloudFront (OAC) — simple example

What this example does
- Creates a private S3 bucket (not a website).
- Creates a CloudFront distribution using an Origin Access Control (OAC).
- Optionally attaches a bucket policy that allows only the CloudFront distribution
	to read objects (recommended for private buckets).

Files
- `main.tf` — example configuration (bucket, CloudFront OAC, optional policy).
- `variables.tf` — example variables.

Quick steps
1. Change to this example folder:

```bash
cd examples/s3-cloudfront-oac
```

2. Initialize providers (no backend):

```bash
terraform init -backend=false
```

3. Validate configuration:

```bash
terraform validate
```

4. (Optional) See plan — requires AWS credentials:

```bash
terraform plan
```

5. Apply — will create real AWS resources (requires credentials):

```bash
terraform apply
# or non-interactive
terraform apply -auto-approve
```

6. Destroy resources when done:

```bash
terraform destroy
terraform destroy -auto-approve
```

Optional outputs.tf
Add this file to print common outputs after apply:

```hcl
output "bucket_name" { 
    value = module.bucket.id 
    }
output "bucket_arn"  { 
    value = module.bucket.arn 
    }
output "cf_distribution_id"   { 
    value = module.cf.distribution_id
     }
output "cf_distribution_arn"  {
     value = module.cf.distribution_arn 
     }
```

Minimum IAM permissions needed to run `apply`
- S3: Create/PutBucket* (CreateBucket, PutBucketPolicy, PutBucketAcl, PutBucketPublicAccessBlock, PutBucketVersioning)
- CloudFront: Create/Update/Delete distributions
- ACM: Request/Describe certificate (only if using a custom domain)

Notes
- The example sets `attach_bucket_policy = true` by default. Set it to `false`
	if you want to manage the bucket policy yourself (e.g. special cross-account
	requirements).
- If you use a custom domain (aliases) with CloudFront, ACM certificate must
	be in `us-east-1`.
- `terraform validate` does not require AWS credentials. `plan` and `apply`
	do and may incur charges.

