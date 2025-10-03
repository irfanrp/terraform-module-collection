variable "policies" {
	description = "Map of policy_name => policy JSON string. Use an empty map to create none."
	type        = map(string)
	default     = {}
}

variable "path" {
	description = "Policy path"
	type        = string
	default     = "/"
}

variable "tags" {
	description = "Optional tags to attach to created policies"
	type        = map(string)
	default     = {}
}
