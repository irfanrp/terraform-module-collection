# Placeholder DNS implementation using null_resource so the module is usable without the Cloudflare provider.
resource "null_resource" "record" {
  for_each = var.dns_records

  triggers = {
    name    = each.key
    type    = tostring(lookup(each.value, "type", "A"))
    value   = tostring(lookup(each.value, "value", ""))
    ttl     = tostring(lookup(each.value, "ttl", 1))
    proxied = tostring(lookup(each.value, "proxied", var.default_proxied))
  }
}

# When you are ready to use the real Cloudflare provider, replace the placeholder above with the resource below
# and ensure you add required_providers = { cloudflare = { source = "cloudflare/cloudflare" } } in the calling configuration.

/*
resource "cloudflare_record" "this" {
  for_each = var.dns_records
  zone_id  = var.zone_id
  name     = each.key
  type     = lookup(each.value, "type", "A")
  value    = lookup(each.value, "value", "")
  ttl      = lookup(each.value, "ttl", 1)
  proxied  = lookup(each.value, "proxied", var.default_proxied)
}
*/
