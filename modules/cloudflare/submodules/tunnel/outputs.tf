output "tunnel_triggers" {
  value = { for k, r in null_resource.tunnel : k => r.triggers }
}
