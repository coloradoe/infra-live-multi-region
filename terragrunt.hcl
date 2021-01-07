locals {
  aws_region = "us-east-1"
}

remote_state {
  backend = "s3"

  config = {
    bucket         = "${local.aws_region}-terraform-state-rdp-488"
    region         = "${local.aws_region}"
    dynamodb_table = "training-terraform"
    encrypt        = true

    key = "${local.aws_region}/${path_relative_to_include()}"

    s3_bucket_tags = {
      owner = "training"
      name  = "traing-state"
    }

    dynamodb_table_tags = {
      owner = "training"
      name  = "training-state"
    }
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"

  contents = <<EOF
  provider "aws" {

      region              = "${local.aws_region}"
}
EOF
}