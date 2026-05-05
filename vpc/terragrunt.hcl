# vpc/terragrunt.hcl

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
  name        = "vpc"
  tags        = include.root.locals.tags
  attributes  = []

  # VPC functional inputs
  cidr_block           = "10.0.0.0/16"
  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}
