# IAM Group submodule

Create an IAM group and optionally attach managed and inline policies.

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `name` | string | n/a | yes | Group name to create. |
| `managed_policy_arns` | list(string) | `[]` | no | Managed policy ARNs to attach to the group. |
| `inline_policies` | map(string) | `{}` | no | Map of inline policy name => policy JSON. |

## Outputs

| Name | Description |
|------|-------------|
| `group_name` | The created group name. |
| `managed_policy_arns` | The list of managed policy ARNs attached. |

Usage examples

Single group with managed policy

```hcl
module "group_devs" {
	source = "../../modules/iam/submodules/group"

	name                = "devs"
	managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
```

Group with inline policy

```hcl
module "group_ops" {
	source = "../../modules/iam/submodules/group"

	name = "ops"
	inline_policies = {
		allow_ssm = jsonencode({ Version = "2012-10-17", Statement = [{ Effect = "Allow", Action = ["ssm:Describe*"], Resource = "*" }] })
	}
}
```

Multiple groups (for_each)

```hcl
locals {
	groups = {
		devs = { managed_policy_arns = ["arn:aws:iam::aws:policy/ReadOnlyAccess"] }
		ops  = { inline_policies = { allow_ssm = jsonencode({ ... }) } }
	}
}

module "groups" {
	source = "../../modules/iam/submodules/group"
	for_each = local.groups
	name = each.key
	managed_policy_arns = try(each.value.managed_policy_arns, [])
	inline_policies = try(each.value.inline_policies, {})
}
```

Notes

- Attaching managed policies uses `aws_iam_group_policy_attachment`/`aws_iam_group_policy` resources; ensure policy ARNs are correct.
- Use `jsonencode()` to build inline policy bodies in HCL safely.
