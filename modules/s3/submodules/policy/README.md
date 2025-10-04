Policy submodule

Accepts a `policies` map of bucket_name => json_policy_string and attaches the policy to the named bucket. Use `jsonencode()` when constructing policies from HCL objects.

Example:

```hcl
module "policy" {
  source = "../../modules/s3/submodules/policy"
  policies = {
    "company-public-assets" = jsonencode({
      Version = "2012-10-17",
      Statement = [{ Effect = "Allow", Action = ["s3:GetObject"], Resource = "arn:aws:s3:::company-public-assets/*" }]
    })
  }
}
```
