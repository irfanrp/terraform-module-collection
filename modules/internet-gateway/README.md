# AWS Internet Gateway Module

This module creates and manages AWS Internet Gateways for VPCs.

## Features

- Create Internet Gateway and attach to VPC
- Optional default route creation in route tables
- Flexible configuration for integration with other modules
- Resource tagging support

## Usage

### Basic Internet Gateway

```terraform
module "internet_gateway" {
  source = "../modules/internet-gateway"

  name   = "main-igw"
  vpc_id = module.vpc.vpc_id

  tags = {
    Environment = "dev"
  }
}
```

### Internet Gateway with Default Route

```terraform
module "internet_gateway" {
  source = "../modules/internet-gateway"

  name               = "main-igw"
  vpc_id             = module.vpc.vpc_id
  create_default_route = true
  route_table_id     = module.public_route_table.route_table_id

  tags = {
    Environment = "dev"
  }
}
```

### Multiple Internet Gateways (for different VPCs)

```terraform
module "igw_prod" {
  source = "../modules/internet-gateway"

  name   = "prod-igw"
  vpc_id = module.vpc_prod.vpc_id

  tags = {
    Environment = "prod"
  }
}

module "igw_dev" {
  source = "../modules/internet-gateway"

  name   = "dev-igw"
  vpc_id = module.vpc_dev.vpc_id

  tags = {
    Environment = "dev"
  }
}
```

## Variables

- `name` - Name for the Internet Gateway (required)
- `vpc_id` - VPC ID to attach the Internet Gateway (required)
- `create_default_route` - Create default route to IGW (default: false)
- `route_table_id` - Route table ID for default route (required if create_default_route is true)
- `tags` - Tags for the Internet Gateway (default: {})

## Outputs

- `internet_gateway_id` - ID of the Internet Gateway
- `internet_gateway_arn` - ARN of the Internet Gateway
- `internet_gateway_owner_id` - Owner ID of the Internet Gateway

## Important Notes

- Each VPC can have only one Internet Gateway attached at a time
- Internet Gateway must be attached to a VPC to route internet traffic
- Routes to the Internet Gateway are typically added to public subnet route tables
- Internet Gateway enables communication between instances in your VPC and the internet
