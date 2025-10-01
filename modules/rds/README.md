# RDS Module

🚧 **Coming Soon** - Amazon Relational Database Service module

## Planned Features

- RDS Instances (MySQL, PostgreSQL, MariaDB)
- Multi-AZ deployment
- Read replicas
- Subnet groups
- Parameter groups
- Option groups
- Automated backups
- Encryption at rest

## Usage (Preview)

```hcl
module "rds" {
  source = "./modules/rds"
  
  identifier = "my-database"
  engine     = "postgres"
  
  allocated_storage = 20
  instance_class    = "db.t3.micro"
  
  db_name  = "myapp"
  username = "admin"
  password = "changeme123!"
  
  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  tags = {
    Environment = "dev"
  }
}
```

Stay tuned for updates!