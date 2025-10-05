output "certificate_arn" {
  description = "ACM certificate ARN"
  value       = var.for_cloudfront && length(aws_acm_certificate.us_east) > 0 ? aws_acm_certificate.us_east[0].arn : aws_acm_certificate.this.arn
}

output "certificate_domain" {
  description = "Primary domain name of the certificate"
  value       = aws_acm_certificate.this.domain_name
}
