output "attached" {
  value = { for k, p in aws_s3_bucket_policy.this : k => p.id }
}
