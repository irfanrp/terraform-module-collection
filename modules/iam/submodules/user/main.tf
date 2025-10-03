resource "aws_iam_user" "this" {
  name = var.name
  path = var.path
}

resource "aws_iam_user_group_membership" "membership" {
  count  = length(var.groups) > 0 ? 1 : 0
  user   = aws_iam_user.this.name
  groups = var.groups
}

resource "aws_iam_access_key" "this" {
  count = var.create_access_key ? 1 : 0
  user  = aws_iam_user.this.name
}
