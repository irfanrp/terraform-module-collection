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

variable "assume_oidc" {
	description = <<EOF
List of OIDC trust blocks to include in the role's assume role policy. Each item is an object with:
- `provider` (string): the OIDC provider ARN (for example: arn:aws:iam::123456789012:oidc-provider/oidc.eks.amazonaws.com/id/XYZ)
- `conditions` (map(string)): optional map of condition keys to values (e.g. {"oidc.eks.amazonaws.com/id/XYZ:sub" = "system:serviceaccount:ns:sa"})
EOF
	type = list(object({
		provider   = string
		conditions = map(string)
	}))
	default = []
}
