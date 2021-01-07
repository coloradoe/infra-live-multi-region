# Terraworkspace

Terraworkspace is a shell script to enable multi-region/multi-environment Terraform deployments by allowing you to quickly create and select Terraform workspaces in the root folder as well as all relevant subdirectories.

### Tech

This repo, along with the coloradoe-infra-modules-multi-region repo, show an example file/folder structure you can use with Terragrunt to keep your Terraform code DRY. For background information, check out the Keep your Terraform code DRY section of the Terragrunt documentation.

## Architecture
An architectural diagram can be found in the root folder of this repo.

## Explanation
The motivation behind the architectural decisions we made was to keep our code as DRY as possible while maintaining as much visibility as we can into what resources and resources' versions we are deploying into each region.

We opted to keep our environments horizontal, meaning all modules used for a particular environment will live under a folder for said environment. 
Regions will be vertical, meaning they will exist within an environment through the use of workspaces.

## Usage

1. The user will start by pulling the infra-modules-multi-region repo into their local computer.
2. The user will add or modify terraform files.
3. The user will commit the changes/additions to VCS
4. The user will tag the change as vX.X.X and push the tag to VCS
5. The user will pull the infra-live-multi-region repo
6. The user will go/create the folder for the environment they are working in
7. The user will add any new module folders (with their respective terragrunt.hcl file) if they do not previously exist
8. The user will modify the terragrunt file in the modules to add the version of the terraform resource they are provisioning
9. The user will go to the root folder for the environment they are working in
10. The user will run terraworkspace.sh with the region flag (-r) and the region in which they want to provision their resources (ex. us-east-1)
11. If the user needs to provision the entire infrastructure they will run terragrunt plan-all
    * If the user only needs to provision a particular module they will go into that folder and run terragrunt plan
12. The user will verify the changes to add/modify in the infrastructure
13. If the user is provisioning the entire infrastructure they will run terragrunt apply-all
    * If the user is provisioning a particular module, they will go into that folder and run terragrunt apply
14. Profit
