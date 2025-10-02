locals {
  common_tags = merge(
    var.tags,
    {
      Module = "ec2"
      Name   = var.name
    }
  )
}

resource "aws_instance" "this" {
  count                       = var.instance_count
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.subnet_ids, count.index % length(var.subnet_ids))
  vpc_security_group_ids      = var.security_group_ids
  associate_public_ip_address = var.associate_public_ip
  monitoring                  = var.enable_detailed_monitoring

  root_block_device {
    volume_size = var.ebs_volume_size
    volume_type = "gp3"
    encrypted   = true
  }

  tags = merge(local.common_tags, {
    Index = tostring(count.index)
  })
}

resource "aws_eip" "this" {
  count = var.associate_public_ip ? var.instance_count : 0

  instance = aws_instance.this[count.index].id

  tags = merge(local.common_tags, {
    Index = tostring(count.index)
    Type  = "eip"
  })
}
