locals {
  names = length(var.bucket_names) > 0 ? var.bucket_names : (var.bucket_name != "" ? [var.bucket_name] : [])
}

locals {
  common_tags = {}
}

# Validation using expressions: fail early with clear messages
locals {
  validated_names        = length(local.names) > 0 ? local.names : error("You must provide at least one bucket name via 'bucket_name' or 'bucket_names'.")
  unknown_policy_keys    = length(var.bucket_policies) > 0 ? setsubtract(keys(var.bucket_policies), local.validated_names) : []
  _check_bucket_policies = length(local.unknown_policy_keys) == 0 ? true : error("All keys in 'bucket_policies' must match a created bucket name (one of: ${join(", ", local.validated_names)})")
}

resource "aws_s3_bucket" "this" {
  for_each      = toset(local.names)
  bucket        = each.value
  force_destroy = var.force_destroy

  dynamic "versioning" {
    for_each = var.versioning_enabled ? [1] : []
    content {
      enabled = true
    }
  }

  dynamic "server_side_encryption_configuration" {
    for_each = var.server_side_encryption_enabled ? [1] : []
    content {
      rule {
        apply_server_side_encryption_by_default {
          sse_algorithm     = var.sse_algorithm
          kms_master_key_id = var.kms_key_id
        }
      }
    }
  }

  dynamic "cors_rule" {
    for_each = var.cors_rules
    content {
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      allowed_headers = lookup(cors_rule.value, "allowed_headers", null)
      expose_headers  = lookup(cors_rule.value, "expose_headers", null)
      max_age_seconds = lookup(cors_rule.value, "max_age_seconds", null)
    }
  }

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rules
    content {
      id      = lookup(lifecycle_rule.value, "id", null)
      enabled = lookup(lifecycle_rule.value, "enabled", true)

      dynamic "transition" {
        for_each = lookup(lifecycle_rule.value, "transitions", [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = lookup(lifecycle_rule.value, "expiration", [])
        content {
          days = expiration.value.days
        }
      }

      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
    }
  }

  dynamic "logging" {
    for_each = var.logging_enabled && var.logging_target_bucket != null ? [1] : []
    content {
      target_bucket = var.logging_target_bucket
      target_prefix = var.logging_target_prefix
    }
  }

  tags = merge(var.tags, { Name = each.value })
}

# Create bucket ACL resource if user provided an acl (avoid using deprecated `acl` argument on aws_s3_bucket)
resource "aws_s3_bucket_acl" "this" {
  for_each = var.acl != null ? aws_s3_bucket.this : {}

  bucket = each.value.id
  acl    = var.acl
}

resource "aws_s3_bucket_public_access_block" "this" {
  for_each = var.enable_public_access_block ? aws_s3_bucket.this : {}

  bucket = each.value.id

  block_public_acls       = var.block_public_acls
  block_public_policy     = var.block_public_policy
  ignore_public_acls      = var.ignore_public_acls
  restrict_public_buckets = var.restrict_public_buckets
}

# Optionally create a bucket policy to enforce TLS and deny public (if requested)
resource "aws_s3_bucket_policy" "deny_insecure_transport" {
  for_each = var.deny_insecure_transport ? aws_s3_bucket.this : {}
  bucket   = each.value.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid       = "DenyInsecureTransport",
        Effect    = "Deny",
        Principal = "*",
        Action    = "s3:*",
        Resource = [
          "${each.value.arn}",
          "${each.value.arn}/*"
        ],
        Condition = {
          Bool = { "aws:SecureTransport" = false }
        }
      }
    ]
  })
}

# Attach user-provided policies per bucket
resource "aws_s3_bucket_policy" "custom_policies" {
  for_each = var.attach_bucket_policies ? { for k, v in var.bucket_policies : k => v if contains(keys(aws_s3_bucket.this), k) } : {}

  bucket = aws_s3_bucket.this[each.key].id
  policy = each.value
}
