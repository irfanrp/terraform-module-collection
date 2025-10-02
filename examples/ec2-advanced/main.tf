terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Create VPC for advanced example
module "vpc" {
  source             = "../../modules/vpc"
  name               = var.vpc_name
  cidr_block         = var.vpc_cidr
  availability_zones = var.availability_zones
  enable_nat_gateway = true  # Enable NAT for private subnets

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Example     = "advanced"
  }
}

# Security group for application servers
resource "aws_security_group" "app" {
  name_prefix = "${var.vpc_name}-ec2-app-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-ec2-app-sg"
    Environment = var.environment
  }
}

# Custom IAM policy for S3 access
resource "aws_iam_policy" "s3_access" {
  name        = "${var.vpc_name}-s3-access-policy"
  description = "Allow EC2 instances to access S3 buckets"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = "arn:aws:s3:::my-app-bucket/*"
      },
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket"
        ]
        Resource = "arn:aws:s3:::my-app-bucket"
      }
    ]
  })

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Key pair for SSH access (optional)
resource "aws_key_pair" "app_key" {
  key_name   = "${var.vpc_name}-app-key"
  public_key = var.ssh_public_key  # You need to provide this variable

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Placement group for high performance
resource "aws_placement_group" "app_cluster" {
  name     = "${var.vpc_name}-app-cluster"
  strategy = "cluster"

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

# Advanced EC2 configuration
module "ec2_advanced" {
  source = "../../modules/ec2"

  name                        = "app-server"
  instance_count              = 3
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_ids                  = module.vpc.private_subnet_ids  # Using private subnets
  security_group_ids          = [aws_security_group.app.id]
  associate_public_ip         = false  # No public IP for security
  key_name                    = aws_key_pair.app_key.key_name
  user_data                   = file("${path.module}/user-data-advanced.sh")
  disable_api_termination     = true   # Production protection
  enable_detailed_monitoring  = true   # Detailed CloudWatch monitoring
  enable_cloudwatch_logs      = true
  enable_cloudwatch_metrics   = true
  placement_group             = aws_placement_group.app_cluster.name
  
  # Additional IAM policies
  additional_iam_policies = [
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    aws_iam_policy.s3_access.arn
  ]

  ebs_volume_size = 20

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Tier        = "application"
    Backup      = "daily"
    Monitoring  = "enhanced"
  }
}

# Bastion host for SSH access to private instances
module "ec2_bastion" {
  source = "../../modules/ec2"

  name                        = "bastion"
  instance_count              = 1
  ami_id                      = data.aws_ami.ubuntu.id
  instance_type               = "t3.nano"
  subnet_ids                  = module.vpc.public_subnet_ids
  security_group_ids          = [aws_security_group.bastion.id]
  associate_public_ip         = true
  key_name                    = aws_key_pair.app_key.key_name
  create_ssm_instance_profile = true
  enable_cloudwatch_logs      = false  # Minimal logging for bastion
  enable_cloudwatch_metrics   = false

  tags = {
    Environment = var.environment
    Project     = var.project_name
    Role        = "bastion"
  }
}

# Security group for bastion host
resource "aws_security_group" "bastion" {
  name_prefix = "${var.vpc_name}-bastion-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-bastion-sg"
    Environment = var.environment
  }
}

# Outputs
output "app_instance_ids" {
  description = "IDs of the application server instances"
  value       = module.ec2_advanced.instance_ids
}

output "app_private_ips" {
  description = "Private IPs of the application servers"
  value       = module.ec2_advanced.private_ips
}

output "bastion_public_ip" {
  description = "Public IP of the bastion host"
  value       = module.ec2_bastion.public_ips[0]
}

output "ssm_connect_commands" {
  description = "Commands to connect to instances via SSM"
  value = [
    for id in module.ec2_advanced.instance_ids :
    "aws ssm start-session --target ${id}"
  ]
}

output "ssh_bastion_command" {
  description = "Command to SSH to bastion host"
  value       = "ssh -i /path/to/private/key ubuntu@${module.ec2_bastion.public_ips[0]}"
}

output "placement_group" {
  description = "Placement group name"
  value       = aws_placement_group.app_cluster.name
}