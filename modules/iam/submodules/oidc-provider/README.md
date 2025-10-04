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

Usage examples

Single OIDC provider (EKS)

```hcl
module "oidc_eks" {
	source = "../../modules/iam/submodules/oidc-provider"

	url             = "https://oidc.eks.region.amazonaws.com/id/EXAMPLED539D4633E53DE1B716D3041E"
	client_id_list  = ["sts.amazonaws.com"]
	thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da0d3b7a3f6"]
}

output "oidc_arn" { value = module.oidc_eks.oidc_provider_arn }
```

Multiple providers (compose in a wrapper)

```hcl
locals { oidc = {
	eks = {
		url = "https://oidc.eks.region.amazonaws.com/id/EXAMPLE"
		client_id_list = ["sts.amazonaws.com"]
		thumbprint_list = ["9e99..."]
	}
}}

module "oidc" {
	source = "../../modules/iam/submodules/oidc-provider"
	for_each = local.oidc
	url = each.value.url
	client_id_list = try(each.value.client_id_list, [])
	thumbprint_list = each.value.thumbprint_list
}
```

Notes

- `thumbprint_list` is required and usually a single item for the issuer certificate. Obtain it from your issuer or cloud provider docs.
- Use `for_each` to create multiple providers from a map.
