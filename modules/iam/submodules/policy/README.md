# IAM Policy submodule

Create one or more standalone IAM policies from supplied JSON. This submodule accepts a `policies` map of `name => policy JSON string`.

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `policies` | map(string) | `{}` | no | Map of policy_name => policy JSON string. Use an empty map to create none. |
| `path` | string | `/` | no | Optional path for the policy. |
| `tags` | map(string) | `{}` | no | Optional tags to attach to created policies |

## Outputs

| Name | Description |
|------|-------------|
| `policy_arns` | Map of created policy name => ARN |
| `policy_names` | Map of created policy name => name |

Usage examples

Single policy

```hcl
module "policy" {
	source = "../../modules/iam/submodules/policy"

	policies = {
		"readonly-s3" = jsonencode({
			Version = "2012-10-17",
			Statement = [{ Effect = "Allow", Action = ["s3:GetObject"], Resource = "*" }]
		})
	}
}

output "readonly_s3_arn" {
	value = module.policy.policy_arns["readonly-s3"]
}
```

Multiple policies

```hcl
module "policy" {
	source = "../../modules/iam/submodules/policy"

	policies = {
		"readonly-s3" = jsonencode({ Version = "2012-10-17", Statement = [...]})
		"write-logs"   = jsonencode({ Version = "2012-10-17", Statement = [...]})
	}
}
```

Notes

- Use `jsonencode()` to build policy documents in HCL (keeps formatting safe).
- Policy names must be unique within the map. The module creates one `aws_iam_policy` resource per map entry.
