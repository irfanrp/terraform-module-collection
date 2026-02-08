resource "aws_acm_certificate" "this" {
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  tags                      = var.tags
}

resource "aws_acm_certificate" "us_east" {
  count                     = var.for_cloudfront ? 1 : 0
  provider                  = aws.us_east_1
  domain_name               = var.domain_name
  subject_alternative_names = var.subject_alternative_names
  validation_method         = var.validation_method
  tags                      = var.tags
}

data "aws_route53_zone" "zone" {
  count        = var.hosted_zone_id == null && var.zone_name != null ? 1 : 0
  name         = var.zone_name
  private_zone = var.private_zone
}

locals {
  hosted_zone_id = var.hosted_zone_id != null ? var.hosted_zone_id : (length(data.aws_route53_zone.zone) > 0 ? data.aws_route53_zone.zone[0].zone_id : null)
}

resource "aws_route53_record" "validation" {
  count = var.create_route53_records && local.hosted_zone_id != null ? length(aws_acm_certificate.this.domain_validation_options) : 0

  zone_id = local.hosted_zone_id
  name    = lookup(aws_acm_certificate.this.domain_validation_options[count.index], "resource_record_name")
  type    = lookup(aws_acm_certificate.this.domain_validation_options[count.index], "resource_record_type")
  records = [lookup(aws_acm_certificate.this.domain_validation_options[count.index], "resource_record_value")]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "this" {
  count = var.validation_method == "DNS" ? 1 : 0

  certificate_arn         = var.for_cloudfront && length(aws_acm_certificate.us_east) > 0 ? aws_acm_certificate.us_east[0].arn : aws_acm_certificate.this.arn
  validation_record_fqdns = var.create_route53_records && local.hosted_zone_id != null ? aws_route53_record.validation[*].fqdn : []
}

resource "aws_acm_certificate_validation" "us_east" {
  count                   = var.for_cloudfront && var.validation_method == "DNS" ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.us_east[0].arn
  validation_record_fqdns = var.create_route53_records && local.hosted_zone_id != null ? aws_route53_record.validation[*].fqdn : []
}
