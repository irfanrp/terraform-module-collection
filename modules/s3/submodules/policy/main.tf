resource "aws_s3_bucket_policy" "this" {
  for_each = var.policies

  bucket = each.key
  policy = each.value
}
