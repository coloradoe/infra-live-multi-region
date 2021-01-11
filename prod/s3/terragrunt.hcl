locals {
  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))

  # Extract out common variables for reuse
  aws_region = local.environment_vars.locals.aws_region
}

include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::git@github.com:coloradoe/coloradoe-infra-modules-multi-region.git//s3?ref=v0.0.12"
}
inputs = {
  bucket_name = "rdp-488-sample-bucket"
  environment_tag = "Production"
  workspace = "${local.aws_region}"
}
