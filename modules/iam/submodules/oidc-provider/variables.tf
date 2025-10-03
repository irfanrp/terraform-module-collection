variable "url" {
	description = "OIDC provider URL"
	type        = string
}

variable "client_id_list" {
	description = "Client IDs"
	type        = list(string)
	default     = []
}

variable "thumbprint_list" {
	description = "Thumbprints"
	type        = list(string)
	default     = []
}
