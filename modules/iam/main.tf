locals {
  role_name_final = var.role_name != null ? var.role_name : (var.name_prefix == "" ? "iam-role" : format("%s%s", var.name_prefix, substr(md5(timestamp()), 0, 6)))
  assume_role_policy_calc = var.assume_role_policy != null ? var.assume_role_policy : jsonencode({
    Version = "2012-10-17"
    Statement = concat([
      for svc in var.assume_services : {
        Effect    = "Allow"
        Principal = { Service = svc }
        Action    = "sts:AssumeRole"
      }
      ], [
      for acct in var.cross_account_principals : {
        Effect    = "Allow"
        Principal = { AWS = acct }
        Action    = "sts:AssumeRole"
      }
    ])
  })
}

locals {
  # Flatten group managed policy attachments -> map key => { group, policy_arn }
  group_managed_list = flatten([
    for gname, g in var.groups : [
      for p in try(g.managed_policy_arns, []) : {
        key        = "${gname}::${replace(p, "/", "_")}"
        group      = gname
        policy_arn = p
      }
    ]
  ])

  group_managed_map = { for item in local.group_managed_list : item.key => { group = item.group, policy_arn = item.policy_arn } }

  group_inline_list = flatten([
    for gname, g in var.groups : [
      for pname, p in try(g.inline_policies, {}) : {
        key         = "${gname}::${pname}"
        group       = gname
        policy_name = pname
        policy      = p
      }
    ]
  ])

  group_inline_map = { for item in local.group_inline_list : item.key => { group = item.group, policy_name = item.policy_name, policy = item.policy } }

  user_managed_list = flatten([
    for uname, u in var.users : [
      for p in try(u.managed_policy_arns, []) : {
        key        = "${uname}::${replace(p, "/", "_")}"
        user       = uname
        policy_arn = p
      }
    ]
  ])

  user_managed_map = { for item in local.user_managed_list : item.key => { user = item.user, policy_arn = item.policy_arn } }

  user_inline_list = flatten([
    for uname, u in var.users : [
      for pname, p in try(u.inline_policies, {}) : {
        key         = "${uname}::${pname}"
        user        = uname
        policy_name = pname
        policy      = p
      }
    ]
  ])

  user_inline_map = { for item in local.user_inline_list : item.key => { user = item.user, policy_name = item.policy_name, policy = item.policy } }

  users_with_keys = { for uname, u in var.users : uname => u if try(u.create_access_key, false) }
}

resource "aws_iam_role" "this" {
  count              = var.create_role ? 1 : 0
  name               = local.role_name_final
  assume_role_policy = local.assume_role_policy_calc
  path               = var.path
  tags               = var.tags
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = var.create_role ? toset(var.managed_policy_arns) : []
  role       = aws_iam_role.this[0].name
  policy_arn = each.value
}

resource "aws_iam_role_policy" "inline" {
  for_each = var.create_role ? var.inline_policies : {}
  name     = each.key
  role     = aws_iam_role.this[0].name
  policy   = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile && var.create_role ? 1 : 0
  name  = var.instance_profile_name != null ? var.instance_profile_name : local.role_name_final
  role  = aws_iam_role.this[0].name
  path  = var.path
}

# Standalone policies
resource "aws_iam_policy" "standalone" {
  for_each = var.policies
  name     = each.key
  policy   = each.value
  path     = var.path
}

# OIDC providers
resource "aws_iam_openid_connect_provider" "oids" {
  for_each        = var.oidc_providers
  url             = each.value.url
  client_id_list  = try(each.value.client_id_list, [])
  thumbprint_list = try(each.value.thumbprint_list, [])
}

# Service-linked roles
resource "aws_iam_service_linked_role" "slr" {
  for_each         = toset(var.service_linked_roles)
  aws_service_name = each.value
}

# Groups
resource "aws_iam_group" "this" {
  for_each = var.groups
  name     = each.key
  path     = try(each.value.path, var.path)
}

resource "aws_iam_group_policy_attachment" "managed" {
  for_each   = local.group_managed_map
  group      = aws_iam_group.this[each.value.group].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_group_policy" "inline" {
  for_each = local.group_inline_map
  name     = each.value.policy_name
  group    = aws_iam_group.this[each.value.group].name
  policy   = each.value.policy
}

# Users
resource "aws_iam_user" "this" {
  for_each = var.users
  name     = each.key
  path     = try(each.value.path, var.path)
  # tags intentionally omitted for compatibility; add tags via separate resource if needed
}

resource "aws_iam_user_group_membership" "memberships" {
  for_each = { for uname, u in var.users : uname => try(u.groups, []) }
  user     = aws_iam_user.this[each.key].name
  groups   = each.value
}

resource "aws_iam_user_policy" "inline" {
  for_each = local.user_inline_map
  user     = aws_iam_user.this[each.value.user].name
  name     = each.value.policy_name
  policy   = each.value.policy
}

resource "aws_iam_user_policy_attachment" "managed" {
  for_each   = local.user_managed_map
  user       = aws_iam_user.this[each.value.user].name
  policy_arn = each.value.policy_arn
}

resource "aws_iam_access_key" "this" {
  for_each = local.users_with_keys
  user     = aws_iam_user.this[each.key].name
}
