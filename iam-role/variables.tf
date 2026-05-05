variable "role_name" {
  description = "Name of the IAM role"
  type        = string
}

variable "environment" {
  description = "Environment tag value"
  type        = string
  default     = "demo"
}

variable "trusted_services" {
  description = "AWS services allowed to assume this role"
  type        = list(string)
  default     = ["ec2.amazonaws.com"]
}

variable "managed_policies" {
  description = "List of IAM managed policy ARNs to attach"
  type        = list(string)
  default     = []
}
