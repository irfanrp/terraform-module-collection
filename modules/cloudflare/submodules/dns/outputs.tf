output "record_ids" {
  value = { for k, r in null_resource.record : k => r.id }
}

output "record_names" {
  value = { for k, r in null_resource.record : k => r.triggers.name }
}
