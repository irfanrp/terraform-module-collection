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

variable "pgp_key" {
  description = "Optional PGP key (ascii-armored) to encrypt the generated password returned by AWS. If provided, `encrypted_console_password` will be available in outputs."
  type        = string
  default     = null
}

variable "create_login_profile" {
  description = "Whether to create an IAM console login profile (password) for the user"
  type        = bool
  default     = false
}

variable "password_reset_required" {
  description = "Whether the user is required to reset password on first login"
  type        = bool
  default     = true
}

# Remove unused password-generation variables to avoid confusion with provider behavior.
