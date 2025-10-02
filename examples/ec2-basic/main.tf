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

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = var.vpc_name
  cidr_block         = var.vpc_cidr
  availability_zones = var.availability_zones
  enable_nat_gateway = false

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

resource "aws_security_group" "web" {
  name_prefix = "${var.vpc_name}-ec2-web-"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.vpc_name}-ec2-web-sg"
    Environment = var.environment
  }
}

module "ec2" {
  source = "../../modules/ec2"

  name                = "web"
  instance_count      = 2
  ami_id              = data.aws_ami.amazon_linux.id
  instance_type       = var.instance_type
  subnet_ids          = module.vpc.public_subnet_ids
  security_group_ids  = [aws_security_group.web.id]
  associate_public_ip = true
  ebs_volume_size     = 12

  tags = {
    Environment = var.environment
    Project     = var.project_name
  }
}

output "instance_ids" {
  value = module.ec2.instance_ids
}

output "public_ips" {
  value = module.ec2.public_ips
}

output "private_ips" {
  value = module.ec2.private_ips
}
