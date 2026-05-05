# iam-role/terragrunt.hcl

locals {}

include "root" {
  path   = find_in_parent_folders()
  expose = true
}

terraform {
  source = "./"

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=5m"]
  }
}

inputs = {
  # Context
  enabled     = true
  namespace   = include.root.locals.namespace
  tenant      = include.root.locals.tenant
  stage       = include.root.locals.stage
  environment = include.root.locals.environment
  name        = "role"
  tags        = include.root.locals.tags
  attributes  = []

  # IAM role functional inputs
  trusted_services = ["ec2.amazonaws.com"]
  managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
