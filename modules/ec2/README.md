# EC2 module

Lightweight Terraform module to create one or more EC2 instances. The README below is intentionally concise — examples and inputs are the minimal set needed to get started.

## Features
- Launch one or more EC2 instances
- Optional public IP association
- Optional SSM instance profile creation for Session Manager access
- Support for user data (plain or base64)
- Attach additional IAM policy ARNs to the instance role

## Quick usage
```hcl
module "ec2" {
  source         = "./modules/ec2"
  name           = "web"
  ami_id         = data.aws_ami.amazon_linux.id
  instance_type  = "t3.micro"
  subnet_ids     = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.web.id]
  instance_count = 2
  # Optional
  associate_public_ip = true
  create_ssm_instance_profile = true
  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| name | Base name for EC2 related resources | string | n/a | yes |
| instance_count | Number of EC2 instances to launch | number | 1 | no |
| instance_type | EC2 instance type | string | "t3.micro" | no |
| ami_id | AMI ID to use for the instances | string | n/a | yes |
| subnet_ids | List of subnet IDs where instances will be placed | list(string) | n/a | yes |
| security_group_ids | List of security group IDs to attach | list(string) | [] | no |
| associate_public_ip | Whether to associate a public IP | bool | true | no |
| create_ssm_instance_profile | Create and attach SSM instance profile for Session Manager | bool | true | no |
| ssm_instance_profile_name | Optional name for the SSM instance profile | string | null | no |
| spot_enabled | Whether to launch instances as EC2 Spot instances | bool | false | no |
| key_name | Name of the AWS key pair for SSH access | string | null | no |
| user_data | User data script to run on instance startup (plain text) | string | null | no |
| user_data_base64 | Base64 encoded user data | string | null | no |
| private_ip | Private IP address to associate with the instance in a VPC | string | null | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs
| Name | Description |
|------|-------------|
| instance_ids | IDs of the EC2 instances |
| public_ips | Public IPs (if associated) |
| private_ips | Private IPs of the instances |
| arns | Instance ARNs |
| ssm_instance_profile_name | Name of the SSM instance profile |
| ssm_instance_profile_arn | ARN of the SSM instance profile |

## Notes
- Prefer creating IAM roles/profiles centrally (e.g. `modules/iam`) and passing `external_instance_profile_name` into this module when possible.
- Ensure the AMI you reference is available in the selected region.
- User-data can be provided as plain text or base64; do not supply both.

For more advanced examples see the `examples/` directory.
