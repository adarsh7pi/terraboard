# iam-role/variables.tf — functional inputs only; context inputs are declared in context.tf

variable "trusted_services" {
  description = "AWS services allowed to assume this role"
  type        = list(string)
}

variable "managed_policies" {
  description = "List of IAM managed policy ARNs to attach"
  type        = list(string)
}
