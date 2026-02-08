variable "cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}

variable "service_name" {
  description = "Name of the ECS service"
  type        = string
}

variable "task_definition_name" {
  description = "Name of the task definition"
  type        = string
}

variable "container_name" {
  description = "Name of the container"
  type        = string
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = null

  validation {
    condition     = var.container_image != null || var.create_ecr_repository
    error_message = "container_image is required unless create_ecr_repository is true."
  }
}

variable "create_ecr_repository" {
  description = "Create an ECR repository for the service"
  type        = bool
  default     = false
}

variable "ecr_repository_name" {
  description = "ECR repository name (required if create_ecr_repository is true)"
  type        = string
  default     = null

  validation {
    condition     = !var.create_ecr_repository || var.ecr_repository_name != null
    error_message = "ecr_repository_name is required when create_ecr_repository is true."
  }
}

variable "ecr_image_tag" {
  description = "Image tag to use when create_ecr_repository is true"
  type        = string
  default     = "latest"
}

variable "ecr_scan_on_push" {
  description = "Enable ECR image scanning on push"
  type        = bool
  default     = true
}

variable "ecr_image_tag_mutability" {
  description = "ECR image tag mutability (MUTABLE or IMMUTABLE)"
  type        = string
  default     = "MUTABLE"
}

variable "ecr_force_delete" {
  description = "Force delete ECR repository with images"
  type        = bool
  default     = false
}

variable "container_port" {
  description = "Port exposed by the container"
  type        = number
}

variable "host_port" {
  description = "Port on the host (optional, defaults to container_port)"
  type        = number
  default     = null
}

variable "cpu" {
  description = "CPU units for the task (256 to 4096 for Fargate)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memory for the task in MB (512 to 30720 for Fargate)"
  type        = number
  default     = 512
}

variable "launch_type" {
  description = "Launch type (FARGATE or EC2)"
  type        = string
  default     = "FARGATE"
}

variable "network_mode" {
  description = "Network mode (awsvpc, bridge, host, none)"
  type        = string
  default     = "awsvpc"
}

variable "requires_compatibilities" {
  description = "Launch type compatibility (FARGATE, EC2)"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "vpc_subnets" {
  description = "VPC subnets for ECS tasks"
  type        = list(string)
}

variable "vpc_security_groups" {
  description = "Security groups for ECS tasks"
  type        = list(string)
}

variable "assign_public_ip" {
  description = "Assign public IP to ECS tasks"
  type        = bool
  default     = false
}

variable "desired_count" {
  description = "Desired number of tasks"
  type        = number
  default     = 1
}

variable "environment_variables" {
  description = "Environment variables for the container"
  type        = list(map(string))
  default     = []
}

variable "load_balancer_config" {
  description = "Load balancer configuration (target_group_arn required)"
  type = object({
    target_group_arn = string
  })
  default = null
}

variable "capacity_providers" {
  description = "Capacity providers (FARGATE, FARGATE_SPOT, or EC2 auto scaling group name)"
  type        = list(string)
  default     = ["FARGATE"]
}

variable "enable_container_insights" {
  description = "Enable CloudWatch Container Insights"
  type        = bool
  default     = true
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
  default     = 7
}

variable "enable_autoscaling" {
  description = "Enable auto scaling for ECS service"
  type        = bool
  default     = false
}

variable "autoscaling_min_capacity" {
  description = "Minimum number of tasks for auto scaling"
  type        = number
  default     = 1
}

variable "autoscaling_max_capacity" {
  description = "Maximum number of tasks for auto scaling"
  type        = number
  default     = 4
}

variable "autoscaling_target_cpu" {
  description = "Target CPU utilization percentage for auto scaling"
  type        = number
  default     = 70
}

variable "autoscaling_target_memory" {
  description = "Target memory utilization percentage for auto scaling"
  type        = number
  default     = 80
}

variable "tags" {
  description = "Tags for resources"
  type        = map(string)
  default     = {}
}

variable "secrets" {
  description = "Secrets from Secrets Manager to inject into container (name = secret_arn)"
  type        = map(string)
  default     = {}
}

variable "create_s3_bucket" {
  description = "Create S3 bucket for the ECS service"
  type        = bool
  default     = false
}

variable "s3_bucket_name" {
  description = "S3 bucket name (required if create_s3_bucket is true)"
  type        = string
  default     = null
}

variable "s3_bucket_permissions" {
  description = "S3 permissions for ECS task (read, write, or both)"
  type        = string
  default     = "read"
  
  validation {
    condition     = contains(["read", "write", "both"], var.s3_bucket_permissions)
    error_message = "S3 permissions must be 'read', 'write', or 'both'."
  }
}

variable "existing_s3_bucket_arn" {
  description = "ARN of existing S3 bucket (use instead of create_s3_bucket)"
  type        = string
  default     = null
}
