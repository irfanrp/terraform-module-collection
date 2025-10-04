terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = { source = "hashicorp/aws", version = "~> 5.0" }
  }
}

provider "aws" { region = "us-east-1" }

module "bucket" {
  source = "../../modules/s3/submodules/bucket"
  key = "example-oac"
  name = "example-oac-bucket-${terraform.workspace}"
  versioning_enabled = false
  tags = { env = "dev" }
}

module "cf" {
  source = "../../modules/s3/submodules/cloudfront_oac"
  name = "example-oac"
  origin_bucket_regional_domain_name = module.bucket.bucket_regional_domain_name
  create_oac = true
  attach_bucket_policy = true
  target_bucket_id = module.bucket.id
  target_bucket_arn = module.bucket.arn
}

# Restrict bucket access to CloudFront distribution only
resource "aws_s3_bucket_policy" "cf_only" {
  bucket = module.bucket.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Sid = "AllowCloudFrontServicePrincipal",
        Effect = "Allow",
        Principal = { Service = "cloudfront.amazonaws.com" },
        Action = "s3:GetObject",
        Resource = "${module.bucket.arn}/*",
        Condition = {
          StringEquals = { "AWS:SourceArn" = module.cf.distribution_arn }
        }
      }
    ]
  })
}
