# RDS Module

Simple RDS instance provisioning for MySQL, Postgres, and MariaDB with optional RDS Proxy support.

## Quick Usage

```hcl
module "rds" {
  source = "../../modules/rds"

  identifier       = "mydb"
  engine           = "postgres"
  instance_class   = "db.t3.micro"
  allocated_storage = 20

  username = "admin"
  password = var.db_password

  vpc_security_group_ids = [aws_security_group.db.id]
  db_subnet_ids          = [aws_subnet.private_1.id, aws_subnet.private_2.id]

  tags = { Environment = "dev" }
}
```

## With RDS Proxy

```hcl
module "rds" {
  source = "../../modules/rds"

  identifier = "mydb"
  engine     = "postgres"
  username   = "admin"
  password   = var.db_password

  create_proxy              = true
  proxy_vpc_subnet_ids      = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  proxy_vpc_security_group_ids = [aws_security_group.proxy.id]

  tags = { Environment = "dev" }
}
```

## Variables

- `identifier` - RDS identifier (required)
- `engine` - Database engine: postgres, mysql, mariadb (required)
- `instance_class` - Instance class (default: db.t3.micro)
- `allocated_storage` - Storage in GB (default: 20)
- `username` - Master username
- `password` - Master password
- `vpc_security_group_ids` - Security groups for DB
- `db_subnet_ids` - Subnet IDs for DB subnet group
- `create_proxy` - Enable RDS Proxy (default: false)
- `proxy_vpc_subnet_ids` - Subnets for RDS Proxy (required if create_proxy=true)
- `proxy_vpc_security_group_ids` - Security groups for RDS Proxy
- `tags` - Resource tags

## Outputs

- `endpoint` - RDS endpoint address
- `port` - Database port
- `id` - RDS instance ID
- `proxy_endpoint` - RDS Proxy endpoint (if enabled)
- `proxy_port` - RDS Proxy port (if enabled)
