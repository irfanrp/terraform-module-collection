# IAM OIDC Provider submodule

Create an IAM OIDC provider resource used for Web Identity Federation (for example EKS OIDC providers).

## Inputs

| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `url` | string | n/a | yes | The OIDC issuer URL (e.g. `https://oidc.eks.<region>.amazonaws.com/id/<id>`). |
| `client_id_list` | list(string) | `[]` | no | Client IDs (audiences) that are allowed. |
| `thumbprint_list` | list(string) | n/a | yes | Certificate thumbprints for the provider. |

## Outputs

| Name | Description |
|------|-------------|
| `oidc_provider_arn` | The created OIDC provider ARN. |
