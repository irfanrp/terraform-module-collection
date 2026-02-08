# Elastic IP for NAT Gateway
resource "aws_eip" "this" {
  count = var.create_eip ? 1 : 0

  domain = "vpc"

  tags = merge(
    var.tags,
    {
      Name = var.eip_name != null ? var.eip_name : "${var.name}-eip"
    }
  )

  depends_on = var.depends_on

  lifecycle {
    create_before_destroy = true
  }
}

# NAT Gateway
resource "aws_nat_gateway" "this" {
  allocation_id = var.create_eip ? aws_eip.this[0].id : var.allocation_id
  subnet_id     = var.subnet_id

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  depends_on = var.depends_on

  lifecycle {
    create_before_destroy = true
  }
}
