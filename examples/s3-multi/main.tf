terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "s3" {
  source = "../../modules/s3"

  buckets = {
    app_data = {
      name                   = "example-app-data-${var.env_suffix}"
      versioning_enabled     = true
      server_side_encryption = { type = "SSE-S3" }
      lifecycle_rules        = [{ id = "expire", status = "Enabled", prefix = "logs/", expiration = [{ days = 365 }] }]
      tags                   = { env = "prod" }
    }

    public_assets = {
      name                   = "example-public-assets-${var.env_suffix}"
      acl                    = "public-read"
      versioning_enabled     = false
      server_side_encryption = { type = "SSE-S3" }
      cors_rules             = [{ allowed_methods = ["GET"], allowed_origins = ["*"] }]
      lifecycle_rules        = []
      tags                   = { env = "prod" }
    }
  }
}

output "bucket_ids" {
  value = module.s3.bucket_ids
}
