resource "aws_cloudfront_origin_access_control" "oac" {
  count = var.create_oac ? 1 : 0

  name        = "${var.name}-oac"
  description = "Origin Access Control for ${var.name}"

  origin_access_control_origin_type = "s3"
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
}

resource "aws_cloudfront_distribution" "this" {
  count = var.enabled ? 1 : 0

  origin {
    domain_name = var.origin_bucket_regional_domain_name
    origin_id   = "s3-${var.name}"

    origin_access_control_id = var.create_oac && length(aws_cloudfront_origin_access_control.oac) > 0 ? aws_cloudfront_origin_access_control.oac[0].id : null

    s3_origin_config {
      origin_access_identity = ""
    }
  }

  enabled = var.enabled

  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "s3-${var.name}"
    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
  }

  price_class = var.price_class
  comment     = var.comment

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = var.certificate_arn != "" ? var.certificate_arn : null
    ssl_support_method  = var.certificate_arn != "" ? "sni-only" : null
  }

  aliases = var.aliases
}

# Optionally attach a restrictive bucket policy so only this CloudFront distribution can GetObject
resource "aws_s3_bucket_policy" "cf_only" {
  count = var.attach_bucket_policy && var.target_bucket_arn != "" ? 1 : 0

  bucket = var.target_bucket_id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "AllowCloudFrontServicePrincipal",
        Effect    = "Allow",
        Principal = { Service = "cloudfront.amazonaws.com" },
        Action    = "s3:GetObject",
        Resource  = "${var.target_bucket_arn}/*",
        Condition = var.source_account != "" ? { StringEquals = { "AWS:SourceArn" = aws_cloudfront_distribution.this[0].arn, "AWS:SourceAccount" = var.source_account } } : { StringEquals = { "AWS:SourceArn" = aws_cloudfront_distribution.this[0].arn } }
      }
    ]
  })
}
