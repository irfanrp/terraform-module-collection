output "user_name" {
	value = aws_iam_user.this.name
}

output "access_key_id" {
	value = try(aws_iam_access_key.this[0].id, null)
}

output "access_key_secret" {
	value     = try(aws_iam_access_key.this[0].secret, null)
	sensitive = true
}

output "encrypted_console_password" {
	description = "PGP-encrypted console password (when `pgp_key` is provided and `create_login_profile = true`)."
	value       = try(aws_iam_user_login_profile.encrypted[0].encrypted_password, null)
	sensitive   = true
}

output "console_password" {
	description = "Plaintext console password if returned by the provider. Prefer `encrypted_console_password` instead."
	value       = try(aws_iam_user_login_profile.this[0].password, null)
	sensitive   = true
}
