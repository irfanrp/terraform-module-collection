# AWS NAT Gateway Module

This module creates and manages AWS NAT Gateways with optional Elastic IP creation.

## Features

- Create NAT Gateway in specified public subnet
- Automatic Elastic IP creation
- Option to use existing Elastic IP
- Configurable dependencies (e.g., Internet Gateway)
- Resource tagging support
- Lifecycle management for graceful updates

## Usage

### Basic NAT Gateway with Auto EIP

```terraform
module "nat_gateway" {
  source = "../modules/nat-gateway"

  name                = "nat-gateway-a"
  subnet_id           = module.public_subnet.subnet_id
  
  tags = {
    Environment = "dev"
  }
}
```

### Multiple NAT Gateways (One per AZ)

```terraform
module "nat_gateways" {
  for_each = toset(["a", "b", "c"])
  source   = "../modules/nat-gateway"

  name      = "nat-gateway-${each.value}"
  subnet_id = module.public_subnets[each.value].subnet_id

  depends_on = [aws_internet_gateway.main]

  tags = {
    Environment = "prod"
    AZ          = each.value
  }
}
```

### Using Existing Elastic IP

```terraform
module "nat_gateway_existing_eip" {
  source = "../modules/nat-gateway"

  name          = "nat-gateway-custom"
  subnet_id     = module.public_subnet.subnet_id
  create_eip    = false
  allocation_id = aws_eip.existing.id

  tags = {
    Environment = "dev"
  }
}
```

## Variables

- `name` - Name for the NAT Gateway (required)
- `subnet_id` - Subnet ID where NAT Gateway will be created (required)
- `create_eip` - Create Elastic IP (default: true)
- `allocation_id` - Existing Elastic IP allocation ID (required if create_eip is false)
- `eip_name` - Custom name for Elastic IP (optional)
- `tags` - Tags for resources (default: {})
- `depends_on` - Resource dependencies (default: [])

## Outputs

- `nat_gateway_id` - ID of the NAT Gateway
- `nat_gateway_public_ip` - Public IP of the NAT Gateway
- `eip_id` - ID of the Elastic IP (if created)
- `eip_allocation_id` - Allocation ID of the Elastic IP
- `eip_public_ip` - Public IP of the Elastic IP (if created)

## Important Notes

- NAT Gateway must be created in a **public subnet** with internet access
- Elastic IP has a small hourly charge when not associated with a running instance
- NAT Gateway requires an Internet Gateway on the VPC
- Use one NAT Gateway per availability zone for high availability
