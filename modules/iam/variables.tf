variable "role_name" {
  description = "Optional explicit name for the IAM role. If not provided, `name_prefix` will be used to generate a name."
  type        = string
  default     = null
}

variable "name_prefix" {
  description = "Name prefix to use when `role_name` is not provided."
  type        = string
  default     = "iam-"
}

variable "assume_role_policy" {
  description = "Optional full JSON assume role policy. If not provided, a sensible default will be created from `assume_services`."
  type        = string
  default     = null
}

variable "assume_services" {
  description = "List of AWS service principals which may assume this role (used to build a default assume role policy)."
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "create_instance_profile" {
  description = "Whether to create and expose an IAM instance profile for the role (useful for EC2)."
  type        = bool
  default     = true
}

variable "instance_profile_name" {
  description = "Optional explicit name for the instance profile. If null, one will be derived from the role name."
  type        = string
  default     = null
}

variable "managed_policy_arns" {
  description = "List of managed policy ARNs to attach to the role."
  type        = list(string)
  default     = []
}

variable "inline_policies" {
  description = "Map of inline policy name => policy JSON string to attach to the role."
  type        = map(string)
  default     = {}
}

variable "path" {
  description = "Path for the IAM role"
  type        = string
  default     = "/"
}

variable "tags" {
  description = "Tags to apply to IAM resources"
  type        = map(string)
  default     = {}
}

variable "create_role" {
  description = "Whether to create the IAM role. If false the module will not create role-related resources (not commonly used)."
  type        = bool
  default     = true
}

variable "policies" {
  description = "Map of standalone IAM policies to create: name => policy JSON string."
  type        = map(string)
  default     = {}
}

variable "users" {
  description = <<-EOT
    Map of user definitions. Each key is the user name and the value is an object with optional keys:
    - path (string)
    - managed_policy_arns (list(string))
    - inline_policies (map(string) of policy JSON)
    - groups (list(string))
    - create_access_key (bool)
  EOT
  type    = map(any)
  default = {}
}

variable "groups" {
  description = <<-EOT
    Map of group definitions. Each key is the group name and the value is an object with optional keys:
    - managed_policy_arns (list(string))
    - inline_policies (map(string) of policy JSON)
    - members (list(string))
  EOT
  type    = map(any)
  default = {}
}

variable "service_linked_roles" {
  description = "List of AWS service names for which to create service-linked roles (e.g. 'elasticloadbalancing.amazonaws.com')."
  type        = list(string)
  default     = []
}

variable "cross_account_principals" {
  description = "Optional list of ARNs (or account principals like 'arn:aws:iam::123456789012:root') to include in the role's assume role policy for cross-account access."
  type        = list(string)
  default     = []
}

variable "oidc_providers" {
  description = <<-EOT
    Map of OIDC providers to create. Each key is a logical name and the value should be an object with:
    - url (string)
    - client_id_list (list(string))
    - thumbprint_list (list(string))
  EOT
  type    = map(any)
  default = {}
}
