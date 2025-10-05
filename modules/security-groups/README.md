# Security Groups module

Small reusable module to create an AWS Security Group with dynamic ingress/egress rules.

## Quick usage
```hcl
module "sg" {
  source = "../../modules/security-groups"
  name   = "example-sg"
  vpc_id = module.vpc.vpc_id
  ingress = [
    { 
    from_port = 22, 
    to_port = 22, 
    protocol = "tcp",
    cidr_blocks = ["0.0.0.0/0"], 
    description = "SSH" },
  ]
  egress = [
    { 
    from_port = 0, 
    to_port = 0, 
    protocol = "-1", 
    cidr_blocks = ["0.0.0.0/0"], 
    description = "all" },
  ]
  tags = { Environment = "dev" }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| name | Name of the security group | string | n/a | yes |
| description | Description | string | "Managed security group" | no |
| vpc_id | VPC ID to create the SG in | string | n/a | yes |
| ingress | List of ingress rule objects | list(object) | [] | no |
| egress | List of egress rule objects | list(object) | [] | no |
| tags | Tags to apply | map(string) | {} | no |

## Outputs
| Name | Description |
|------|-------------|
| security_group_id | ID of the created security group |
| security_group_arn | ARN of the created security group |
