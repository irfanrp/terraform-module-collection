variable "name" {
  description = "Name for the Internet Gateway"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where the Internet Gateway will be attached"
  type        = string
}

variable "create_default_route" {
  description = "Create a default route to the Internet Gateway in a route table"
  type        = bool
  default     = false
}

variable "route_table_id" {
  description = "Route table ID where the default route will be created (required if create_default_route is true)"
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags to assign to the Internet Gateway"
  type        = map(string)
  default     = {}
}
