variable "name" {
  description = "Name for the subnet"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the subnet will be created"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the subnet"
  type        = string
}

variable "map_public_ip_on_launch" {
  description = "Enable mapping of public IP on instance launch"
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the subnet"
  type        = map(string)
  default     = {}
}
