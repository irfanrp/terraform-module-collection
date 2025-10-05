provider "aws" {
  region = var.region
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = "example-vpc"
  availability_zones = ["${var.region}a", "${var.region}b"]
}

module "sg" {
  source = "../../modules/security-groups"
  name   = "rds-sg"
  vpc_id = module.vpc.vpc_id
  ingress = [
    {
      from_port   = 5432,
      to_port     = 5432, protocol = "tcp",
      cidr_blocks = ["10.0.0.0/16"],
      description = "Postgres"
    }
  ]
  egress = [
    {
      from_port   = 0,
      to_port     = 0,
      protocol    = "-1",
      cidr_blocks = ["0.0.0.0/0"],
      description = "all"
    }
  ]
}

module "rds" {
  source                 = "../../modules/rds"
  identifier             = "example-db"
  engine                 = "postgres"
  allocated_storage      = 20
  instance_class         = "db.t3.micro"
  db_name                = "example"
  username               = "admin"
  password               = "examplepassword"
  vpc_security_group_ids = [module.sg.security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  tags = {
    Environment = "dev"
  }
}
