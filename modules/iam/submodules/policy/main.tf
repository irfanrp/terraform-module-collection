resource "aws_iam_policy" "this" {
  name   = var.name
  policy = var.policy
  path   = var.path
}
