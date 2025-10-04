output "bucket_ids" {
  description = "Map of bucket name -> bucket id"
  value       = { for k, m in module.bucket : k => m.id }
}

output "bucket_arns" {
  description = "Map of bucket name -> bucket arn"
  value       = { for k, m in module.bucket : k => m.arn }
}

output "bucket_domain_names" {
  description = "Map of bucket name -> bucket domain name"
  value       = { for k, m in module.bucket : k => m.bucket_domain_name }
}

output "bucket_regional_domain_names" {
  description = "Map of bucket name -> regional domain name"
  value       = { for k, m in module.bucket : k => m.bucket_regional_domain_name }
}
