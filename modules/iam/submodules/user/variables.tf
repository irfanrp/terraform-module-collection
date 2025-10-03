variable "name" {
	description = "IAM user name"
	type        = string
}

variable "path" {
	description = "IAM user path"
	type        = string
	default     = "/"
}

variable "groups" {
	description = "Groups to add the user to"
	type        = list(string)
	default     = []
}

variable "create_access_key" {
	description = "Create an access key for the user"
	type        = bool
	default     = false
}

variable "tags" {
	description = "Tags for user resources"
	type        = map(string)
	default     = {}
}
