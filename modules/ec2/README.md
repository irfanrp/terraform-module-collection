# EC2 Module

Terraform module to deploy one or more EC2 instances with optional Elastic IPs.

## Features
- Multiple instances with round-robin subnet placement
- Optional Elastic IP association
- Encrypted gp3 root volume (size configurable)
- Optional detailed monitoring
- Tag merging & consistent naming

## Usage
```hcl
module "ec2" {
  source = "./modules/ec2"

  name              = "web"
  instance_count    = 2
  ami_id            = data.aws_ami.amazon_linux.id
  instance_type     = "t3.micro"
  subnet_ids        = module.vpc.public_subnet_ids
  security_group_ids = [aws_security_group.web.id]
  associate_public_ip = true
  ebs_volume_size     = 16

  tags = {
    Environment = "dev"
    Project     = "demo"
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
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs
| Name | Description |
|------|-------------|
| instance_ids | IDs of the EC2 instances |
| public_ips | Public IPs (if associated) |
| private_ips | Private IPs of the instances |
| arns | Instance ARNs |

## Notes
- Ensure the AMI you reference is available in the selected region.
- When using Elastic IPs, AWS limits may apply.
- For production, consider adding:
  - SSM agent access / IAM role
  - CloudWatch log/metric agents
  - Auto scaling groups instead of static count
