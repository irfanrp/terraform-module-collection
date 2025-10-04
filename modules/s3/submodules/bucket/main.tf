resource "random_pet" "suffix" {
  length = 2
}

resource "aws_s3_bucket" "this" {
  bucket        = var.name != "" ? var.name : format("%s-%s", var.key, random_pet.suffix.id)
  force_destroy = var.force_destroy

  dynamic "versioning" {
    for_each = var.versioning_enabled ? [1] : []
    content { enabled = true }
  }

  tags = var.tags
}

resource "aws_s3_bucket_public_access_block" "this" {
  count = length(keys(var.public_access_block)) > 0 ? 1 : 0

  bucket = aws_s3_bucket.this.id

  block_public_acls       = lookup(var.public_access_block, "block_public_acls", true)
  block_public_policy     = lookup(var.public_access_block, "block_public_policy", true)
  ignore_public_acls      = lookup(var.public_access_block, "ignore_public_acls", true)
  restrict_public_buckets = lookup(var.public_access_block, "restrict_public_buckets", true)
}

resource "aws_s3_bucket_server_side_encryption_configuration" "this" {
  count = var.server_side_encryption.type == "SSE-KMS" ? 1 : 0

  bucket = aws_s3_bucket.this.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
      kms_master_key_id = var.server_side_encryption.kms_key_id
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  count  = length(var.lifecycle_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rules
    content {
      id     = lookup(rule.value, "id", null)
      status = lookup(rule.value, "status", "Enabled")

      dynamic "filter" {
        for_each = lookup(rule.value, "prefix", []) != [] ? [1] : []
        content {
          prefix = lookup(rule.value, "prefix", null)
        }
      }

      dynamic "transition" {
        for_each = lookup(rule.value, "transitions", [])
        content {
          days          = transition.value.days
          storage_class = transition.value.storage_class
        }
      }

      dynamic "expiration" {
        for_each = lookup(rule.value, "expiration", [])
        content {
          days = expiration.value.days
        }
      }
    }
  }
}

resource "aws_s3_bucket_cors_configuration" "this" {
  count  = length(var.cors_rules) > 0 ? 1 : 0
  bucket = aws_s3_bucket.this.id

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
}
