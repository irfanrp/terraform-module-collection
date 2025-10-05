locals {
  subnet_group_needed = var.db_subnet_group_name == null && length(var.db_subnet_ids) > 0
  subnet_group_name = var.db_subnet_group_name != null ? var.db_subnet_group_name : "${var.identifier}-subnet-group"
}

resource "aws_db_subnet_group" "this" {
  count = local.subnet_group_needed ? 1 : 0

  name       = local.subnet_group_name
  subnet_ids = var.db_subnet_ids
  description = "DB subnet group for ${var.identifier}"
  tags = var.tags
}

resource "aws_db_instance" "this" {
  identifier = var.identifier
  engine     = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class
  allocated_storage = var.allocated_storage

  username = var.username
  password = var.password

  vpc_security_group_ids = var.vpc_security_group_ids

  db_subnet_group_name = local.subnet_group_name

  publicly_accessible = var.publicly_accessible

  skip_final_snapshot = var.skip_final_snapshot

  tags = var.tags
}
