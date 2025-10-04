variable "policies" {
  description = "Map of policy name => policy JSON string (jsonencode)."
  type        = map(string)
  default     = {}
}
