locals {
  names = length(var.bucket_names) > 0 ? var.bucket_names : (var.bucket_name != "" ? [var.bucket_name] : [])
}

# Bridge: if user provided legacy bucket_names/bucket_name, convert to new buckets map
locals {
  legacy_buckets_map = length(local.names) > 0 ? { for n in local.names : n => { name = n } } : {}
  buckets_map        = length(var.buckets) > 0 ? var.buckets : local.legacy_buckets_map
}

locals {
  common_tags = {}
}

# Validation: require at least one bucket (legacy or new map)
locals {
  validated_buckets = length(keys(local.buckets_map)) > 0 ? local.buckets_map : error("You must provide at least one bucket via the 'buckets' map or legacy 'bucket_name/bucket_names' variables.")
}

module "bucket" {
  source   = "./submodules/bucket"
  for_each = local.validated_buckets

  key                    = each.key
  name                   = try(each.value.name, "")
  acl                    = try(each.value.acl, null)
  force_destroy          = try(each.value.force_destroy, false)
  versioning_enabled     = try(each.value.versioning_enabled, var.versioning_enabled)
  server_side_encryption = try(each.value.server_side_encryption, { type = var.sse_algorithm == "aws:kms" ? "SSE-KMS" : "SSE-S3" })
  lifecycle_rules        = try(each.value.lifecycle_rules, var.lifecycle_rules)
  cors_rules             = try(each.value.cors_rules, var.cors_rules)
  logging                = try(each.value.logging, { target_bucket = var.logging_target_bucket, target_prefix = var.logging_target_prefix })
  public_access_block    = try(each.value.public_access_block, var.enable_public_access_block ? { block_public_acls = var.block_public_acls, block_public_policy = var.block_public_policy, ignore_public_acls = var.ignore_public_acls, restrict_public_buckets = var.restrict_public_buckets } : {})
  tags                   = try(each.value.tags, var.tags)
}
