variable "name" {
	description = "Policy logical name"
	type        = string
}

variable "policy" {
	description = "Policy JSON string"
	type        = string
}

variable "path" {
	description = "Policy path"
	type        = string
	default     = "/"
}
