include {
  path = find_in_parent_folders()
}

terraform {
   source = "git::git@github.com:coloradoe/coloradoe-infra-modules-multi-region.git?ref=v0.0.1"
}

dependencies {
  paths = ["../vpc"]
}
dependency "vpc" {
  config_path = "../vpc"

  mock_outputs_allowed_terraform_commands = ["validate","plan"]

  mock_outputs = {
    vpc = ({
      id = "fake-id"
    })
  }
}

inputs = {
  vpc  = dependency.vpc.outputs.vpc
}
