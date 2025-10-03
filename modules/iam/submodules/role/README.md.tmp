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
