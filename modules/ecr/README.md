# ECR Repository Module

Simple module to create an ECR repository with optional lifecycle and repository policies.

## Quick Usage

```hcl
module "ecr" {
  source = "../../modules/ecr"

  name = "my-app"

  tags = {
    Environment = "dev"
  }
}
```

## With Lifecycle Policy

```hcl
module "ecr" {
  source = "../../modules/ecr"

  name = "my-app"

  lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 10 images"
        selection = {
          tagStatus   = "any"
          countType   = "imageCountMoreThan"
          countNumber = 10
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}
```

## Variables

- `name` - ECR repository name (required)
- `image_tag_mutability` - MUTABLE or IMMUTABLE (default: MUTABLE)
- `scan_on_push` - Enable image scanning (default: true)
- `kms_key_arn` - KMS key ARN for encryption (optional)
- `force_delete` - Force delete repository (default: false)
- `lifecycle_policy` - Lifecycle policy JSON (optional)
- `repository_policy` - Repository policy JSON (optional)
- `tags` - Resource tags

## Outputs

- `repository_name` - ECR repository name
- `repository_arn` - ECR repository ARN
- `repository_url` - ECR repository URL
- `registry_id` - Registry ID
