
# ACM Certificate

Lightweight module to request an ACM certificate and (optionally) perform DNS validation using Route53. Designed for automated workflows where the module can create the validation records for you.

## Features
- Request ACM certificate (supports SANs)
- Optional Route53 lookup (by zone name) and automatic DNS validation
- Outputs certificate ARN ready to attach to CloudFront or ALB

## Quick usage
```hcl
module "cert" {
  source = "../../modules/acm-certificate"
  domain_name = "example.com"
  subject_alternative_names = ["www.example.com"]
  zone_name = "example.com"
  create_route53_records = true
  tags = { 
    Environment = "dev" 
    }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| domain_name | Primary domain name for the certificate (e.g. example.com) | string | n/a | yes |
| subject_alternative_names | List of SANs to include on the certificate | list(string) | [] | no |
| validation_method | ACM validation method (DNS or EMAIL). DNS is recommended for automation. | string | "DNS" | no |
| hosted_zone_id | Optional Route53 hosted zone id to use for DNS validation | string | null | no |
| zone_name | Optional Route53 zone name to look up when hosted_zone_id is not provided (e.g. example.com) | string | null | no |
| private_zone | When looking up zone by name, set true to search private zones | bool | false | no |
| create_route53_records | Create DNS validation records automatically in the found hosted zone | bool | true | no |
| tags | Tags to apply to created resources | map(string) | {} | no |

## Outputs
| Name | Description |
|------|-------------|
| certificate_arn | ARN of the requested ACM certificate |
| certificate_domain | Primary domain name on the certificate |

## Notes
- Route53 zone lookup: if `hosted_zone_id` is not provided the module will try to find a zone by `zone_name` in the account (set `private_zone = true` to search private hosted zones).
- If `create_route53_records = false` you must perform DNS validation manually; the module will not validate the certificate automatically.
- CloudFront requires ACM certificates in the `us-east-1` region. If you plan to use the cert with CloudFront, request the certificate in `us-east-1` (this module requests in the provider region — add provider aliasing if you need cross-region issuance).
- The module does not create Route53 hosted zones; it only creates records in an existing zone.

## Requesting cert in us-east-1 for CloudFront
When `for_cloudfront = true` the module will request an additional certificate in `us-east-1`. To enable this you must configure a provider alias in your root module, for example:

```hcl
provider "aws" {
  region = "us-east-1"
  alias  = "use_east_1"
}

module "cert" {
  source = "../modules/acm-certificate"
  domain_name = "example.com"
  zone_name = "example.com"
  for_cloudfront = true
}
```

The module will use `aws.use_east_1` provider to request the CloudFront certificate and perform validation using the same Route53 records (Route53 is global so the records must exist in the hosted zone).

