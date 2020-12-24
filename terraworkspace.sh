#!/bin/bash

# Get the region
while getopts r: flag
do
    case "${flag}" in
        r) region=${OPTARG};;
        *)
    esac
done

array=()

for i in $(terraform workspace list| sed 's/*//g')
do
    array+=("$i")
    echo "array[$i]"
done

if [[ ! " ${array[*]} " =~ " $region " ]];
then
    echo "Creating $region"
    # Create workspace if workspace doesn't exist
    terraform workspace new "$region"
    # Create workspace in all subdirectories
    for d in ./*/ ; do (cd "$d" && terraform workspace new "$region");done
fi

if [[ " ${array[*]} " =~ " $region " ]];
then
    echo "Selecting $region"
    # Select the workspace
    terraform workspace select "$region"
    # Select workspace in all subdirectories
    for d in ./*/ ; do (cd "$d" && terraform workspace select "$region");done
fi

# Set region in terragrunt file
hclq set 'locals.aws_region' "$region" < terragrunt.hcl | sponge terragrunt.hcl

