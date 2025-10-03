locals {
  assume_policy = var.assume_role_policy != null ? var.assume_role_policy : jsonencode({
    Version = "2012-10-17",
    Statement = [for svc in var.assume_services : {
      Effect = "Allow",
      Principal = { Service = svc },
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role" "this" {
  name = var.name
  assume_role_policy = local.assume_policy
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each = toset(var.managed_policy_arns)
  role = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.inline_policies
  name     = each.key
  role     = aws_iam_role.this.name
  policy   = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.name
  role  = aws_iam_role.this.name
}
