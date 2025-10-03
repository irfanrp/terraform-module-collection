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
