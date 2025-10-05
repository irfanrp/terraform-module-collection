variable "name" {
  description = "Base name for EC2 related resources"
  type        = string
}

variable "instance_count" {
  description = "Number of EC2 instances to launch"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ami_id" {
  description = "AMI ID to use for the instances"
  type        = string
}

variable "subnet_ids" {
  description = "List of subnet IDs where instances will be placed"
  type        = list(string)
}

variable "associate_public_ip" {
  description = "Whether to associate a public IP"
  type        = bool
  default     = true
}

variable "security_group_ids" {
  description = "List of security group IDs to attach"
  type        = list(string)
  default     = []
}

variable "ebs_volume_size" {
  description = "Root EBS volume size in GB"
  type        = number
  default     = 8
}

variable "enable_detailed_monitoring" {
  description = "Enable detailed monitoring (CloudWatch)"
  type        = bool
  default     = false
}

variable "create_ssm_instance_profile" {
  description = "Whether to create and attach SSM instance profile"
  type        = bool
  default     = true
}

variable "ssm_instance_profile_name" {
  description = "Name for the SSM instance profile (optional, will be auto-generated if not provided)"
  type        = string
  default     = null
}

variable "external_instance_profile_name" {
  description = "Optional external instance profile name to attach to instances. If provided, the module will not create an SSM role/instance profile and will use this profile name for instances."
  type        = string
  default     = null
}

variable "key_name" {
  description = "Name of the AWS key pair for SSH access"
  type        = string
  default     = null
}

variable "user_data" {
  description = "User data script to run on instance startup"
  type        = string
  default     = null
}

variable "user_data_base64" {
  description = "Base64 encoded user data script"
  type        = string
  default     = null
}

variable "disable_api_termination" {
  description = "Enable EC2 instance termination protection"
  type        = bool
  default     = false
}

variable "enable_cloudwatch_logs" {
  description = "Enable CloudWatch logs agent permissions"
  type        = bool
  default     = true
}

variable "enable_cloudwatch_metrics" {
  description = "Enable CloudWatch custom metrics permissions"
  type        = bool
  default     = true
}

variable "additional_iam_policies" {
  description = "List of additional IAM policy ARNs to attach to the instance role"
  type        = list(string)
  default     = []
}

variable "placement_group" {
  description = "Placement group for the instances"
  type        = string
  default     = null
}

variable "tenancy" {
  description = "Tenancy of the instance (default, dedicated, host)"
  type        = string
  default     = "default"
  validation {
    condition     = contains(["default", "dedicated", "host"], var.tenancy)
    error_message = "Tenancy must be one of: default, dedicated, host."
  }
}

variable "spot_enabled" {
  description = "Whether to launch instances as EC2 Spot instances"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "private_ip_addresses" {
  description = "Optional list of private IP addresses to assign to instances. If provided, instances will receive IPs by round-robin from this list. Leave empty to let AWS auto-assign private IPs."
  type        = list(string)
  default     = []
}

variable "private_ip" {
  description = "Private IP address to associate with the instance in a VPC"
  type        = string
  default     = null
}
