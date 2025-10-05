output "bucket_id" {
  description = "The S3 bucket id (name) created for snapshot exports"
  value       = aws_s3_bucket.export_bucket.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.export_bucket.arn
}

output "role_arn" {
  description = "ARN of the IAM role to be assumed by RDS for export"
  value       = aws_iam_role.rds_snapshot_export_role.arn
}

output "policy_arn" {
  description = "ARN of the IAM policy attached to the role"
  value       = aws_iam_policy.rds_export_policy.arn
}
