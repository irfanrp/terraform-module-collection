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
    example = {
      name                   = "tf-module-collection-example-bucket-${var.env_suffix}"
      acl                    = "private"
      versioning_enabled     = true
      server_side_encryption = { type = "SSE-S3" }
      tags                   = { Environment = var.environment, Project = var.project_name }
    }
  }
}

output "bucket_ids" {
  description = "Map of bucket name -> bucket id"
  value       = module.s3.bucket_ids
}

output "bucket_arns" {
  description = "Map of bucket name -> bucket arn"
  value       = module.s3.bucket_arns
}
