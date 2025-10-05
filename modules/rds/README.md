# RDS wrapper module

Lightweight wrapper to provision an RDS instance (MySQL/Postgres/MariaDB) using sensible defaults. This README is concise — use the examples in `examples/` for full configurations.

## Quick usage
```hcl
module "rds" {
  source = "./modules/rds"

  identifier = "my-database"
  engine     = "postgres"
  engine_version = "15"

  allocated_storage = 20
  instance_class    = "db.t3.micro"

  db_name  = "myapp"
  username = "admin"
  password = var.db_password

  vpc_security_group_ids = [module.sg.security_group_id]
  db_subnet_group_name   = module.vpc.database_subnet_group_name

  tags = {
    Environment = "dev"
  }
}
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-------:|:--------:|
| identifier | RDS identifier (base name) | string | n/a | yes |
| engine | Database engine (postgres, mysql, mariadb) | string | n/a | yes |
| engine_version | Optional engine version | string | null | no |
| allocated_storage | Allocated storage (GB) | number | 20 | no |
| instance_class | RDS instance class | string | "db.t3.micro" | no |
| db_name | Initial database name | string | null | no |
| username | Master username | string | null | no |
| password | Master password | string | null | no |
| vpc_security_group_ids | Security groups to attach | list(string) | [] | no |
| db_subnet_group_name | DB subnet group name | string | null | no |
| backup_retention_period | Days to retain backups | number | 7 | no |
| backup_window | Preferred backup window | string | null | no |
| maintenance_window | Preferred maintenance window | string | null | no |
| tags | Tags to apply to resources | map(string) | {} | no |

## Outputs
| Name | Description |
|------|-------------|
| endpoint | The RDS endpoint address |
| port | The database port |
| id | The RDS DB instance id |

For advanced setups (read replicas, option groups, parameter groups), wire the underlying resources or see `examples/` for extended patterns.