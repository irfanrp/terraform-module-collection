variable "name" {
  description = "IAM group name"
  type        = string
}

variable "path" {
  description = "Group path"
  type        = string
  default     = "/"
}

variable "managed_policy_arns" {
  description = "Managed ARNs to attach"
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Inline policies map"
  type        = map(string)
  default     = {}
}
