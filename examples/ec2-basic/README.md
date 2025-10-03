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

### Assigning Private IPs

You can optionally assign fixed private IP addresses to the instances in this example by setting `private_ip_addresses` in a `terraform.tfvars` file. The module will assign IPs in round-robin order to the instances. If you leave the list empty (the default), AWS will auto-assign private IPs.

Example `terraform.tfvars` snippet:

```hcl
private_ip_addresses = ["10.50.1.10", "10.50.1.11"]
```

Notes:
- Ensure the private IPs you choose are within the subnet CIDR and not already in use.
- If you provide fewer IPs than instances, the module will rotate through the list (round-robin). If you prefer strict 1:1 mapping, consider adding an explicit validation in the module.

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
