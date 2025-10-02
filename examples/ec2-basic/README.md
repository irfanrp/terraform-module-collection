# EC2 Basic Example

This example provisions:
- A VPC (via vpc module)
- Security group for SSH + HTTP
- Two EC2 instances using the EC2 module
- Public IPs

## Usage
```bash
cd examples/ec2-basic
terraform init
terraform plan
terraform apply
```

## Variables Override (terraform.tfvars)
```hcl
aws_region        = "us-west-2"
instance_type     = "t3.small"
availability_zones = ["us-west-2a", "us-west-2b"]
```

## Clean Up
```bash
terraform destroy
```
