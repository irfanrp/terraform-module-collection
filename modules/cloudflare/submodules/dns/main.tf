resource "cloudflare_dns_record" "this" {
  for_each = var.dns_records
  zone_id  = var.zone_id
  name     = each.key
  type     = lookup(each.value, "type", "A")
  content  = lookup(each.value, "value", "")
  ttl      = lookup(each.value, "ttl", 1)
  proxied  = lookup(each.value, "proxied", var.default_proxied)
}
