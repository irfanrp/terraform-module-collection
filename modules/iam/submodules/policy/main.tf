locals {
  # support legacy single-policy inputs if users still set them (optional)
  policies_map = length(var.policies) > 0 ? var.policies : {}
}

resource "aws_iam_policy" "this" {
  for_each = local.policies_map
  name     = each.key
  policy   = each.value
  path     = var.path
  tags     = var.tags
}
