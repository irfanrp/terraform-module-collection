# IAM Policy submodule

Create a standalone IAM policy from supplied JSON.

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `name` | string | n/a | yes | Name for the policy resource. |
| `policy` | string | n/a | yes | The policy document JSON. |
| `path` | string | `/` | no | Optional path for the policy. |

## Outputs

| Name | Description |
|------|-------------|
| `policy_arn` | The created policy ARN. |
| `policy_name` | The created policy name. |
