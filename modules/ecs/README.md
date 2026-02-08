# ECS Module

ECS cluster with task definition, service, optional auto scaling, Secrets Manager, and S3 support.

## Quick Usage

```hcl
module "ecs" {
  source = "../../modules/ecs"

  cluster_name         = "my-cluster"
  service_name         = "my-service"
  task_definition_name = "my-task"

  container_name  = "app"
  container_image = "nginx:latest"
  container_port  = 80

  cpu    = 256
  memory = 512

  vpc_subnets       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  vpc_security_groups = [aws_security_group.ecs.id]

  tags = { Environment = "dev" }
}
```

## With Secrets Manager

```hcl
module "ecs" {
  source = "../../modules/ecs"

  cluster_name         = "my-cluster"
  service_name         = "my-service"
  task_definition_name = "my-task"

  container_name  = "app"
  container_image = "nginx:latest"
  container_port  = 80

  vpc_subnets       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  vpc_security_groups = [aws_security_group.ecs.id]

  secrets = {
    DB_PASSWORD = aws_secretsmanager_secret.db_password.arn
    API_KEY     = aws_secretsmanager_secret.api_key.arn
  }

  tags = { Environment = "prod" }
}
```

## With S3 Bucket

```hcl
module "ecs" {
  source = "../../modules/ecs"

  cluster_name         = "my-cluster"
  service_name         = "my-service"
  task_definition_name = "my-task"

  container_name  = "app"
  container_image = "nginx:latest"
  container_port  = 80

  vpc_subnets       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  vpc_security_groups = [aws_security_group.ecs.id]

  create_s3_bucket      = true
  s3_bucket_name        = "my-app-bucket-${data.aws_caller_identity.current.account_id}"
  s3_bucket_permissions = "both"  # read, write, or both

  tags = { Environment = "prod" }
}
```

## With ECR Repository

```hcl
module "ecs" {
  source = "../../modules/ecs"

  cluster_name         = "my-cluster"
  service_name         = "my-service"
  task_definition_name = "my-task"

  container_name = "app"
  container_port = 80

  create_ecr_repository = true
  ecr_repository_name   = "my-app"
  ecr_image_tag         = "latest"

  vpc_subnets         = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  vpc_security_groups = [aws_security_group.ecs.id]

  tags = { Environment = "prod" }
}
```

## With Load Balancer and Auto Scaling

```hcl
module "ecs" {
  source = "../../modules/ecs"

  cluster_name         = "my-cluster"
  service_name         = "my-service"
  task_definition_name = "my-task"

  container_name  = "app"
  container_image = "nginx:latest"
  container_port  = 80

  vpc_subnets       = [aws_subnet.private_1.id, aws_subnet.private_2.id]
  vpc_security_groups = [aws_security_group.ecs.id]

  load_balancer_config = {
    target_group_arn = aws_lb_target_group.app.arn
  }

  enable_autoscaling       = true
  autoscaling_min_capacity = 2
  autoscaling_max_capacity = 10
  autoscaling_target_cpu   = 70

  tags = { Environment = "prod" }
}
```

## Variables

- `cluster_name` - ECS cluster name (required)
- `service_name` - ECS service name (required)
- `task_definition_name` - Task definition name (required)
- `container_name` - Container name (required)
- `container_image` - Docker image (required)
- `container_port` - Container port (required)
- `cpu` - CPU units (default: 256)
- `memory` - Memory in MB (default: 512)
- `launch_type` - FARGATE or EC2 (default: FARGATE)
- `vpc_subnets` - VPC subnets (required)
- `vpc_security_groups` - Security groups (required)
- `desired_count` - Desired tasks (default: 1)
- `secrets` - Secrets Manager secrets map (name = arn)
- `create_ecr_repository` - Create ECR repository (default: false)
- `ecr_repository_name` - ECR repository name (required if create_ecr_repository=true)
- `ecr_image_tag` - Image tag used with created ECR (default: latest)
- `ecr_scan_on_push` - Enable ECR scan on push (default: true)
- `ecr_image_tag_mutability` - ECR tag mutability (default: MUTABLE)
- `ecr_force_delete` - Force delete ECR repository (default: false)
- `create_s3_bucket` - Create S3 bucket (default: false)
- `s3_bucket_name` - S3 bucket name (required if create_s3_bucket=true)
- `s3_bucket_permissions` - S3 permissions: read, write, both (default: read)
- `existing_s3_bucket_arn` - Use existing S3 bucket ARN
- `load_balancer_config` - Load balancer config with target_group_arn
- `enable_autoscaling` - Enable auto scaling (default: false)
- `autoscaling_min_capacity` - Min tasks (default: 1)
- `autoscaling_max_capacity` - Max tasks (default: 4)
- `autoscaling_target_cpu` - Target CPU % (default: 70)
- `autoscaling_target_memory` - Target memory % (default: 80)
- `tags` - Resource tags

## Outputs

- `cluster_name` - ECS cluster name
- `cluster_arn` - ECS cluster ARN
- `service_name` - ECS service name
- `service_arn` - ECS service ARN
- `task_definition_arn` - Task definition ARN
- `log_group_name` - CloudWatch log group name
- `s3_bucket_name` - S3 bucket name (if created)
- `s3_bucket_arn` - S3 bucket ARN
- `ecr_repository_name` - ECR repository name (if created)
- `ecr_repository_arn` - ECR repository ARN (if created)
- `ecr_repository_url` - ECR repository URL (if created)
