locals {
  subnet_group_needed = var.db_subnet_group_name == null && length(var.db_subnet_ids) > 0
  subnet_group_name   = var.db_subnet_group_name != null ? var.db_subnet_group_name : "${var.identifier}-subnet-group"
}

resource "aws_db_subnet_group" "this" {
  count = local.subnet_group_needed ? 1 : 0

  name        = local.subnet_group_name
  subnet_ids  = var.db_subnet_ids
  description = "DB subnet group for ${var.identifier}"
  tags        = var.tags
}

resource "aws_db_instance" "this" {
  identifier        = var.identifier
  engine            = var.engine
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage

  username = var.username
  password = var.password

  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = local.subnet_group_name

  publicly_accessible = var.publicly_accessible

  skip_final_snapshot = var.skip_final_snapshot

  tags = var.tags
}

# RDS Proxy
resource "aws_db_proxy" "this" {
  count = var.create_proxy ? 1 : 0

  name          = "${var.identifier}-proxy"
  engine_family = upper(var.engine) == "POSTGRES" ? "POSTGRESQL" : upper(var.engine)
  auth {
    auth_scheme = "SECRETS"
    secret_arn  = aws_secretsmanager_secret.db_secret[0].arn
  }

  role_arn               = aws_iam_role.proxy_role[0].arn
  vpc_subnet_ids         = var.proxy_vpc_subnet_ids
  vpc_security_group_ids = var.proxy_vpc_security_group_ids

  tags = var.tags
}

resource "aws_db_proxy_default_target_group" "this" {
  count = var.create_proxy ? 1 : 0

  db_proxy_name = aws_db_proxy.this[0].name
}

resource "aws_db_proxy_target" "this" {
  count = var.create_proxy ? 1 : 0

  target_group_name      = aws_db_proxy_default_target_group.this[0].name
  db_proxy_name          = aws_db_proxy.this[0].name
  target_arn             = aws_db_instance.this.arn
  db_instance_identifier = aws_db_instance.this.id
}

# Secrets Manager Secret for RDS Proxy
resource "aws_secretsmanager_secret" "db_secret" {
  count = var.create_proxy ? 1 : 0

  name                    = "${var.identifier}-secret"
  recovery_window_in_days = 0
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "db_secret" {
  count = var.create_proxy ? 1 : 0

  secret_id = aws_secretsmanager_secret.db_secret[0].id
  secret_string = jsonencode({
    username = var.username
    password = var.password
  })
}

# IAM Role for RDS Proxy
resource "aws_iam_role" "proxy_role" {
  count = var.create_proxy ? 1 : 0

  name = "${var.identifier}-proxy-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "rds.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

resource "aws_iam_role_policy" "proxy_policy" {
  count = var.create_proxy ? 1 : 0

  name = "${var.identifier}-proxy-policy"
  role = aws_iam_role.proxy_role[0].id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds"
        ]
        Resource = aws_secretsmanager_secret.db_secret[0].arn
      }
    ]
  })
}
