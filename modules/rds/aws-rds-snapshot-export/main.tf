resource "aws_s3_bucket" "export_bucket" {
  bucket = var.bucket_name

  acl    = "private"

  force_destroy = var.force_destroy

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = var.sse_algorithm
      }
    }
  }

  versioning {
    enabled = var.versioning
  }

  lifecycle_rule {
    id      = "expire-objects"
    enabled = var.lifecycle_enabled

    expiration {
      days = var.lifecycle_days
    }
  }

  tags = var.tags
}

resource "aws_iam_role" "rds_snapshot_export_role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.rds_assume_role.json
  tags               = var.tags
}

data "aws_iam_policy_document" "rds_assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["rds.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_policy" "rds_export_policy" {
  name   = "${var.role_name}-policy"
  policy = data.aws_iam_policy_document.rds_export_policy.json
}

resource "aws_iam_role_policy_attachment" "attach_export_policy" {
  role       = aws_iam_role.rds_snapshot_export_role.name
  policy_arn = aws_iam_policy.rds_export_policy.arn
}

data "aws_iam_policy_document" "rds_export_policy" {
  statement {
    sid    = "AllowS3Put"
    effect = "Allow"
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:AbortMultipartUpload",
      "s3:ListMultipartUploadParts",
      "s3:GetBucketLocation"
    ]
    resources = [
      aws_s3_bucket.export_bucket.arn,
      "${aws_s3_bucket.export_bucket.arn}/*"
    ]
  }

  statement {
    sid    = "AllowKMS"
    effect = var.kms_enabled ? "Allow" : "Deny"
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = var.kms_key_arn != "" ? [var.kms_key_arn] : ["*"]
  }
}
