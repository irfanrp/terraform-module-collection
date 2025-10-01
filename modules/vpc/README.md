# VPC Module

A Terraform module for creating a VPC with public and private subnets across multiple availability zones.

## Features

- ✅ VPC with configurable CIDR block
- ✅ Public and private subnets
- ✅ Internet Gateway
- ✅ NAT Gateway (optional)
- ✅ Route tables and associations
- ✅ DNS support

## Usage

```hcl
module "vpc" {
  source = "./modules/vpc"
  
  name               = "my-vpc"
  cidr_block         = "10.0.0.0/16"
  availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
  enable_nat_gateway = true
  
  tags = {
    Environment = "production"
    Project     = "my-project"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Name prefix for all resources | `string` | n/a | yes |
| cidr_block | CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| availability_zones | List of availability zones | `list(string)` | n/a | yes |
| enable_dns_hostnames | Enable DNS hostnames for the VPC | `bool` | `true` | no |
| enable_dns_support | Enable DNS support for the VPC | `bool` | `true` | no |
| enable_nat_gateway | Enable NAT Gateway for private subnets | `bool` | `true` | no |
| tags | A map of tags to assign to the resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | ID of the VPC |
| vpc_cidr_block | CIDR block of the VPC |
| internet_gateway_id | ID of the Internet Gateway |
| public_subnet_ids | IDs of the public subnets |
| private_subnet_ids | IDs of the private subnets |
| public_subnet_cidrs | CIDR blocks of the public subnets |
| private_subnet_cidrs | CIDR blocks of the private subnets |
| nat_gateway_ids | IDs of the NAT Gateways |
| public_route_table_id | ID of the public route table |
| private_route_table_ids | IDs of the private route tables |

## Examples

See the [examples](../../examples/) directory for complete examples.