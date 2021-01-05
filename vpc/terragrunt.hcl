include {
  path = find_in_parent_folders()
}
terraform {
  source = "git::git@github.com:coloradoe/coloradoe-infra-modules-multi-region.git//vpc?ref=v0.0.2"
}
inputs = {
  instance_count = 2
  instance_type  = "t2.small"
}
