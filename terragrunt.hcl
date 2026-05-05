locals {
  region     = get_env("AWS_DEFAULT_REGION", "us-east-1")
  account_id = get_aws_account_id()
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

    # Auto-create the bucket and lock table if they don't exist
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
