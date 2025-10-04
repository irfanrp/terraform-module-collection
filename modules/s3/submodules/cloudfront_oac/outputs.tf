output "distribution_id" {
  value = length(aws_cloudfront_distribution.this) > 0 ? aws_cloudfront_distribution.this[0].id : ""
}

output "distribution_arn" {
  value = length(aws_cloudfront_distribution.this) > 0 ? aws_cloudfront_distribution.this[0].arn : ""
}
