include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "./"
}

inputs = {
  role_name        = "terraboard-demo-role"
  environment      = "demo"
  trusted_services = ["ec2.amazonaws.com"]
  managed_policies = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
}
