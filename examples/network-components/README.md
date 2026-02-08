# Network Components Example

This example demonstrates how to use the subnet, internet-gateway, and nat-gateway modules together to build a complete network infrastructure.

## Architecture

The example creates:
- 1 VPC with public and private subnets across multiple availability zones
- 1 Internet Gateway for public internet access
- Multiple NAT Gateways (one per AZ) for private subnet internet access
- Public and private route tables with appropriate routes

## Structure

```
VPC (10.0.0.0/16)
├── Internet Gateway
├── Public Subnets (10.0.{0,1,2}.0/24)
│   ├── NAT Gateway A (10.0.0.x)
│   ├── NAT Gateway B (10.0.1.x)
│   └── NAT Gateway C (10.0.2.x)
├── Public Route Table
│   └── Route: 0.0.0.0/0 → IGW
├── Private Subnets (10.0.{100,101,102}.0/24)
└── Private Route Tables
    ├── Route A: 0.0.0.0/0 → NAT A
    ├── Route B: 0.0.0.0/0 → NAT B
    └── Route C: 0.0.0.0/0 → NAT C
```

## Usage

### Initialize Terraform

```bash
terraform init
```

### Plan the deployment

```bash
terraform plan
```

### Apply the configuration

```bash
terraform apply
```

### Custom variables

```bash
terraform apply -var="project_name=myproject" \
                 -var="environment=prod" \
                 -var="availability_zones=[\"us-west-2a\",\"us-west-2b\"]"
```

## Outputs

The example provides:
- VPC ID and CIDR
- Internet Gateway ID
- Public subnet IDs per AZ
- Private subnet IDs per AZ
- NAT Gateway IDs and public IPs per AZ
- Route table IDs

## Key Features

1. **High Availability**: NAT Gateways in each AZ ensure private subnets can reach the internet even if one AZ fails
2. **Modular Design**: Uses separate modules for subnet, internet-gateway, and nat-gateway
3. **Flexible Configuration**: Easy to customize availability zones, CIDR blocks, and tags
4. **Complete Example**: Shows how to use the modules together with route tables and associations

## Cleanup

```bash
terraform destroy
```

## Notes

- Each NAT Gateway incurs a hourly charge, even when not in use
- Elastic IPs are automatically created for each NAT Gateway
- Instances in private subnets will use their respective NAT Gateway for outbound internet access
- DNS names resolve correctly for both public and private subnets
