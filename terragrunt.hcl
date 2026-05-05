# TERRAGRUNT ROOT - terraboard-infra-example
# Root configuration: remote state, provider, and context locals inherited by all children.

locals {
  region     = get_env("AWS_DEFAULT_REGION", "us-east-1")
  account_id = get_aws_account_id()

  # Context values propagated to every child module via inputs
  namespace   = "7pi"
  tenant      = "terraboard"
  stage       = "demo"
  environment = "demo"
  tags        = { ManagedBy = "TerraBoard" }
}

remote_state {
  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket         = "terraboard-tfstate-${local.account_id}"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = "terraboard-tflock"

    s3_bucket_tags = {
      ManagedBy = "TerraBoard"
    }
    dynamodb_table_tags = {
      ManagedBy = "TerraBoard"
    }
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}
