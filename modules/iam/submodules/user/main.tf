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

# Note: we intentionally avoid configuring a plaintext password on the login profile because many
# provider versions manage the password automatically. If you need a generated password, provide a
# `pgp_key` to receive the encrypted password returned by the provider.

resource "aws_iam_user_login_profile" "this" {
  count                   = var.create_login_profile && var.pgp_key == null ? 1 : 0
  user                    = aws_iam_user.this.name
  password_reset_required = var.password_reset_required
}

resource "aws_iam_user_login_profile" "encrypted" {
  count   = var.create_login_profile && var.pgp_key != null ? 1 : 0
  user    = aws_iam_user.this.name
  pgp_key = var.pgp_key
}
