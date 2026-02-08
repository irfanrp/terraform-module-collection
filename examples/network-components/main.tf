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

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.project_name}-vpc"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}

# Internet Gateway
module "internet_gateway" {
  source = "../../modules/internet-gateway"

  name   = "${var.project_name}-igw"
  vpc_id = aws_vpc.main.id

  tags = {
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Public Subnets
module "public_subnets" {
  for_each = toset(var.availability_zones)

  source = "../../modules/subnet"

  name              = "${var.project_name}-public-${each.value}"
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(var.availability_zones, each.value))
  availability_zone = each.value

  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-public-${each.value}"
    Type        = "public"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = module.internet_gateway.internet_gateway_id
  }

  tags = {
    Name        = "${var.project_name}-public-rt"
    Type        = "public"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  for_each = module.public_subnets

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.public.id
}

# NAT Gateways (one per AZ)
module "nat_gateways" {
  for_each = toset(var.availability_zones)

  source = "../../modules/nat-gateway"

  name      = "${var.project_name}-nat-${each.value}"
  subnet_id = module.public_subnets[each.value].subnet_id

  depends_on = [module.internet_gateway.internet_gateway_id]

  tags = {
    Environment = var.environment
    Project     = var.project_name
    AZ          = each.value
    ManagedBy   = "Terraform"
  }
}

# Private Subnets
module "private_subnets" {
  for_each = toset(var.availability_zones)

  source = "../../modules/subnet"

  name              = "${var.project_name}-private-${each.value}"
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, index(var.availability_zones, each.value) + 100)
  availability_zone = each.value

  tags = {
    Name        = "${var.project_name}-private-${each.value}"
    Type        = "private"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Private Route Tables (one per AZ for NAT Gateway)
resource "aws_route_table" "private" {
  for_each = toset(var.availability_zones)

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.nat_gateways[each.value].nat_gateway_id
  }

  tags = {
    Name        = "${var.project_name}-private-rt-${each.value}"
    Type        = "private"
    Environment = var.environment
    Project     = var.project_name
    ManagedBy   = "Terraform"
  }
}

# Associate Private Subnets with Private Route Tables
resource "aws_route_table_association" "private" {
  for_each = module.private_subnets

  subnet_id      = each.value.subnet_id
  route_table_id = aws_route_table.private[each.key].id
}
