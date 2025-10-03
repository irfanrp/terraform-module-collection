output "record_ids" {
  description = "Map of record_name => record id"
  value       = { for k, r in cloudflare_dns_record.this : k => r.id }
}

output "record_names" {
  description = "Map of record_name => created record name"
  value       = { for k, r in cloudflare_dns_record.this : k => r.name }
}
