# VPC Basic Example

This example demonstrates how to use the VPC module to create a basic VPC with public and private subnets.

## What this creates

- VPC with CIDR `10.0.0.0/16`
- Public subnets in 2 AZs
- Private subnets in 2 AZs
- Internet Gateway
- NAT Gateways for private subnets
- Example security group for web servers

## Usage

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd terraform-modules/examples/vpc-basic
   ```

2. **Initialize Terraform**
   ```bash
   terraform init
   ```

3. **Review the plan**
   ```bash
   terraform plan
   ```

4. **Apply the configuration**
   ```bash
   terraform apply
   ```

5. **Clean up**
   ```bash
   terraform destroy
   ```

## Customization

You can customize the deployment by creating a `terraform.tfvars` file:

```hcl
aws_region          = "us-east-1"
vpc_name           = "my-vpc"
vpc_cidr           = "172.16.0.0/16"
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c"]
environment        = "production"
project_name       = "my-project"
```

## Outputs

After applying, you'll get outputs including:
- VPC ID
- Subnet IDs
- Security Group ID

Use these outputs to reference the created resources in other Terraform configurations.