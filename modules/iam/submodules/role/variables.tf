variable "name" {
	description = "Role name"
	type        = string
}

variable "assume_role_policy" {
	description = "Full JSON assume role policy"
	type        = string
	default     = null
}

variable "assume_services" {
	description = "List of service principals"
	type        = list(string)
	default     = ["ec2.amazonaws.com"]
}

variable "managed_policy_arns" {
	description = "Managed policies to attach"
	type        = list(string)
	default     = []
}

variable "inline_policies" {
	description = "Inline policies map"
	type        = map(string)
	default     = {}
}

variable "create_instance_profile" {
	description = "Create instance profile"
	type        = bool
	default     = false
}
