output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.this.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.this.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.this.arn
}

output "task_definition_arn" {
  description = "ARN of the task definition"
  value       = aws_ecs_task_definition.this.arn
}

output "task_definition_revision" {
  description = "Revision of the task definition"
  value       = aws_ecs_task_definition.this.revision
}

output "log_group_name" {
  description = "CloudWatch log group name"
  value       = aws_cloudwatch_log_group.ecs.name
}

output "task_execution_role_arn" {
  description = "ARN of the task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the task role"
  value       = aws_iam_role.ecs_task_role.arn
}

output "s3_bucket_name" {
  description = "S3 bucket name (if created)"
  value       = var.create_s3_bucket ? aws_s3_bucket.this[0].id : null
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = local.s3_bucket_arn
}

output "ecr_repository_name" {
  description = "ECR repository name (if created)"
  value       = var.create_ecr_repository ? aws_ecr_repository.this[0].name : null
}

output "ecr_repository_arn" {
  description = "ECR repository ARN (if created)"
  value       = var.create_ecr_repository ? aws_ecr_repository.this[0].arn : null
}

output "ecr_repository_url" {
  description = "ECR repository URL (if created)"
  value       = var.create_ecr_repository ? aws_ecr_repository.this[0].repository_url : null
}
