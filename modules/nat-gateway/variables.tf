variable "name" {
  description = "Name for the NAT Gateway"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID where the NAT Gateway will be created (should be a public subnet)"
  type        = string
}

variable "create_eip" {
  description = "Create Elastic IP for NAT Gateway"
  type        = bool
  default     = true
}

variable "allocation_id" {
  description = "Allocation ID of an existing Elastic IP (required if create_eip is false)"
  type        = string
  default     = null
}

variable "eip_name" {
  description = "Name for the Elastic IP (optional, defaults to {name}-eip)"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the NAT Gateway and Elastic IP"
  type        = map(string)
  default     = {}
}
