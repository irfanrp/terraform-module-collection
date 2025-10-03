# EC2 Module

Terraform module to deploy one or more EC2 instances with optional Elastic IPs and SSM support.

## Features
- Multiple instances with round-robin subnet placement
- Optional Elastic IP association
- Encrypted gp3 root volume (size configurable)
- Optional detailed monitoring
- **SSM (Systems Manager) support with automatic IAM role creation**
- **Public IP association control**
- **CloudWatch Logs and Metrics integration**
- **User data script support (plain text or base64)**
- **SSH Key pair support**
- **Instance termination protection**
- **Custom IAM policies attachment**
- **Placement group and tenancy control**
- Tag merging & consistent naming

## Usage
```hcl
# Basic usage
module "ec2" {
  source = "./modules/ec2"

  name                        = "web"
  instance_count              = 2
  ami_id                      = data.aws_ami.amazon_linux.id
  instance_type               = "t3.micro"
  subnet_ids                  = module.vpc.public_subnet_ids
  security_group_ids          = [aws_security_group.web.id]
  associate_public_ip         = true
  ebs_volume_size             = 16
  create_ssm_instance_profile = true  # Enable SSM access
  ssm_instance_profile_name   = "custom-ssm-profile"  # Optional custom name

  tags = {
    Environment = "dev"
    Project     = "demo"
  }
}

# Advanced usage with user data and additional features
module "ec2_advanced" {
  source = "./modules/ec2"

  name                        = "app-server"
  instance_count              = 1
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = "t3.small"
  subnet_ids                  = module.vpc.private_subnet_ids
  security_group_ids          = [aws_security_group.app.id]
  associate_public_ip         = false
  key_name                    = "my-key-pair"
  user_data                   = file("${path.module}/user-data/setup.sh")
  disable_api_termination     = true
  enable_cloudwatch_logs      = true
  enable_cloudwatch_metrics   = true
  
  additional_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    aws_iam_policy.custom_policy.arn

  ## Integrating with an external IAM module (recommended)

  If you manage IAM resources in a separate module (for example `modules/iam`), you can create the role and instance profile there and then pass the profile name into the EC2 module. This avoids duplicate IAM resources and keeps IAM policies and principals centralized.

  Example wiring:

  ```hcl
  module "iam_ssm" {
    source = "../../modules/iam"

    name_prefix             = "ec2-ssm-"
    assume_services         = ["ec2.amazonaws.com"]
    managed_policy_arns     = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
      "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    ]
    create_instance_profile = true
  }

  module "ec2" {
    source = "../../modules/ec2"

    # ...other inputs (name, ami_id, subnet_ids, etc.) ...
    create_ssm_instance_profile        = false
    external_instance_profile_name     = module.iam_ssm.instance_profile_name
  }
  ```

  Notes:
  - `external_instance_profile_name` takes precedence. If you provide it, the EC2 module will not create its own SSM role/profile and will use the supplied profile name for `iam_instance_profile` on `aws_instance`.
  - Prefer centralizing IAM (roles, policies, OIDC providers) in one module and referencing outputs from that module in compute modules. This makes reviews and policy changes safer.
  - Ensure the IAM instance profile exists (or is created in the same Terraform apply via the `iam` module) before instances try to use it. When both modules are in the same root configuration Terraform will order them automatically based on the output reference.
  ]

  tags = {
    Environment = "production"
    Project     = "my-app"
    Backup      = "daily"
  }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | Base name for EC2 related resources | string | n/a | yes |
| instance_count | Number of EC2 instances to launch | number | 1 | no |
| instance_type | EC2 instance type | string | "t3.micro" | no |
| ami_id | AMI ID to use for the instances | string | n/a | yes |
| subnet_ids | List of subnet IDs where instances will be placed | list(string) | n/a | yes |
| associate_public_ip | Whether to associate a public IP | bool | true | no |
| security_group_ids | List of security group IDs to attach | list(string) | [] | no |
| ebs_volume_size | Root EBS volume size in GB | number | 8 | no |
| enable_detailed_monitoring | Enable detailed monitoring (CloudWatch) | bool | false | no |
| create_ssm_instance_profile | Whether to create and attach SSM instance profile | bool | true | no |
| ssm_instance_profile_name | Name for the SSM instance profile (optional, will be auto-generated if not provided) | string | null | no |
| key_name | Name of the AWS key pair for SSH access | string | null | no |
| user_data | User data script to run on instance startup | string | null | no |
| user_data_base64 | Base64 encoded user data script | string | null | no |
| disable_api_termination | Enable EC2 instance termination protection | bool | false | no |
| enable_cloudwatch_logs | Enable CloudWatch logs agent permissions | bool | true | no |
| enable_cloudwatch_metrics | Enable CloudWatch custom metrics permissions | bool | true | no |
| additional_iam_policies | List of additional IAM policy ARNs to attach to the instance role | list(string) | [] | no |
| placement_group | Placement group for the instances | string | null | no |
| tenancy | Tenancy of the instance (default, dedicated, host) | string | "default" | no |
| tags | Tags to apply to resources | map(string) | {} | no |
| private_ip_addresses | Optional list of private IP addresses to assign to instances (round-robin) | list(string) | [] | no |

## Outputs
| Name | Description |
|------|-------------|
| instance_ids | IDs of the EC2 instances |
| public_ips | Public IPs (if associated) |
| private_ips | Private IPs of the instances |
| arns | Instance ARNs |
| ssm_instance_profile_name | Name of the SSM instance profile |
| ssm_instance_profile_arn | ARN of the SSM instance profile |
| ssm_role_arn | ARN of the SSM IAM role |
| availability_zones | Availability zones where instances are deployed |
| subnet_ids | Subnet IDs where instances are deployed |
| key_name | Key pair name used for instances |

## User Data Examples

The module includes example user data scripts in the `user-data-examples/` directory:

- `amazon-linux-setup.sh` - Sets up Apache web server with CloudWatch agent on Amazon Linux 2023
- `ubuntu-setup.sh` - Sets up Nginx web server with CloudWatch agent on Ubuntu

Usage:
```hcl
module "ec2" {
  source = "./modules/ec2"
  
  # ... other variables ...
  
  user_data = file("${path.module}/modules/ec2/user-data-examples/amazon-linux-setup.sh")
}
```

## Notes
- Ensure the AMI you reference is available in the selected region.
- When using Elastic IPs, AWS limits may apply.
- **SSM support**: The module automatically creates an IAM role with `AmazonSSMManagedInstanceCore` policy attached, allowing you to connect to instances via AWS Systems Manager Session Manager without SSH keys.
- **Public IP control**: Use `associate_public_ip` parameter to control whether instances get public IPs assigned.
- **CloudWatch integration**: When enabled, instances get permissions to send logs and custom metrics to CloudWatch.
- **User data**: You can provide either plain text user data or base64 encoded user data, but not both.
- **Termination protection**: Enable `disable_api_termination` for production instances to prevent accidental termination.
- For production, consider adding:
  - Auto scaling groups instead of static count
  - Additional IAM policies as needed
  - Backup strategies for EBS volumes
