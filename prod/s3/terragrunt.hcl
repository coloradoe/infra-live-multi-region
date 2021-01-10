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
  source = "git::git@github.com:coloradoe/coloradoe-infra-modules-multi-region.git//s3?ref=v0.0.10"
}
inputs = {
  bucket_name = "rdp-sample-bucket-${local.aws_region}"
  environment_tag = "SampleEnv"
  workspace = "${local.aws_region}"
}
