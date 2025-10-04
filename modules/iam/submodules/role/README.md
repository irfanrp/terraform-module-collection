# IAM Role submodule

Create an IAM role, attach managed and inline policies, and optionally create an instance profile. This role supports OIDC-based trust relationships (for example EKS service accounts).

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `name` | string | n/a | yes | Role name to create. |
| `assume_role_policy` | string | `null` | no | Full JSON assume role policy. If provided this overrides the generated policy. |
| `assume_services` | list(string) | `["ec2.amazonaws.com"]` | no | Service principals to allow assume role (used when `assume_role_policy` is not set). |
| `assume_oidc` | list(object) | `[]` | no | List of OIDC trust objects with `provider` (ARN) and `conditions` (map) to allow web identity assume (see module README). |
| `managed_policy_arns` | list(string) | `[]` | no | Managed policy ARNs to attach to the role. |
| `inline_policies` | map(string) | `{}` | no | Map of inline policy name => policy JSON. |
| `create_instance_profile` | bool | `false` | no | Create an instance profile with the same name as the role. |

## Outputs

| Name | Description |
|------|-------------|
| `role_name` | The created role name. |
| `role_arn` | The role ARN. |
| `instance_profile_name` | The instance profile name if created, otherwise null. |

Usage examples

EC2 role + instance profile (SSM)

```hcl
module "role_ec2" {
	source = "../../modules/iam/submodules/role"

	name                    = "app-ec2-role"
	assume_services         = ["ec2.amazonaws.com"]
	managed_policy_arns     = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
	create_instance_profile = true
}

# Use in EC2 module
resource "aws_instance" "example" {
	# ...
	iam_instance_profile = module.role_ec2.instance_profile_name
}
```

OIDC / EKS role (web identity)

```hcl
module "role_eks" {
	source = "../../modules/iam/submodules/role"

	name = "eks-serviceaccount-role"
	assume_oidc = [
		{
			provider   = "arn:aws:iam::123456789012:oidc-provider/oidc.eks.region.amazonaws.com/id/EXAMPLE"
			conditions = { "oidc.eks.region.amazonaws.com/id/EXAMPLE:sub" = "system:serviceaccount:my-namespace:my-sa" }
		}
	]
	managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"]
}

```

Notes

- If `assume_role_policy` is provided it overrides the generated policy. Use that when you need custom trust JSON.
- `create_instance_profile` will create an `aws_iam_instance_profile` resource with the same name as the role when true.
