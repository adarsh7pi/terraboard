include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "./"
}

inputs = {
  vpc_name             = "terraboard-demo"
  cidr_block           = "10.0.0.0/16"
  environment          = "demo"

  public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnet_cidrs = ["10.0.11.0/24", "10.0.12.0/24"]

  enable_nat_gateway   = false
  enable_dns_hostnames = true
  enable_dns_support   = true
}
