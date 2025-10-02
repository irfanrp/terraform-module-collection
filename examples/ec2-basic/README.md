# EC2 Basic Example

This example provisions:
- A VPC (via vpc module)
- Security group for SSH + HTTP
- Two EC2 instances using the EC2 module with **SSM support**
- Public IPs
- **SSM instance profile for secure access via AWS Session Manager**

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

## Accessing Instances
With SSM enabled, you can connect to your instances using AWS Session Manager without SSH keys:

```bash
# List instances
aws ec2 describe-instances --filters "Name=tag:Name,Values=web*" --query 'Reservations[*].Instances[*].[InstanceId,Tags[?Key==`Name`].Value|[0],State.Name]' --output table

# Connect to instance via Session Manager
aws ssm start-session --target <instance-id>
```

Make sure you have the Session Manager plugin installed: https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html
