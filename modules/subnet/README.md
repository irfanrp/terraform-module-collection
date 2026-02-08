# AWS Subnet Module

This module creates and manages AWS subnets with minimal configuration.

## Features

- Create subnets in specified VPC and availability zone
- Optional public IP mapping for instances
- Configurable tags for resource management
- Simple and focused module - only manages subnet resource

## Usage

### Public Subnet

```terraform
module "public_subnet" {
  source = "../modules/subnet"

  name              = "public-subnet-a"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  map_public_ip_on_launch = true

  tags = {
    Environment = "dev"
    Type        = "public"
  }
}
```

### Private Subnet

```terraform
module "private_subnet" {
  source = "../modules/subnet"

  name              = "private-subnet-a"
  vpc_id            = module.vpc.vpc_id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Environment = "dev"
    Type        = "private"
  }
}
```

## Variables

- `name` - Name for the subnet (required)
- `vpc_id` - VPC ID where the subnet will be created (required)
- `cidr_block` - CIDR block for the subnet (required)
- `availability_zone` - Availability zone for the subnet (required)
- `map_public_ip_on_launch` - Enable public IP mapping (default: false)
- `tags` - Tags for resources (default: {})

## Outputs

- `subnet_id` - ID of the created subnet
- `subnet_cidr_block` - CIDR block of the subnet
- `subnet_arn` - ARN of the subnet
- `availability_zone` - Availability zone of the subnet

## Notes

- This module only creates the subnet resource
- Routing should be managed separately using the internet-gateway or nat-gateway modules
- Route table association should be handled separately as needed
