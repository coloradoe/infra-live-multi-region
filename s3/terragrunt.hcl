include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::git@github.com:coloradoe/coloradoe-infra-modules-multi-region.git//s3?ref=v0.0.4"
}
inputs = {
  bucket_name="rdp-sample-bucket"
  environment_tag="SampleEnv"
}
