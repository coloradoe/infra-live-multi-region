#!/bin/bash
usage() {
cat << EOF
usage: bash ./terraworkspace.sh -r workspace_name
-r    | --workspace_name (Required)  Workspace name must match [us-east-1| us-east-2| us-west-1 | us-west-2]
-h    | --help                       Brings up this menu
EOF
}
#
# Display the usage message if no arguments are supplied
#
if [ $# -eq 0 ]
then
    usage
    exit
fi

while getopts r:h:*: flag
do
    case "${flag}" in
    r)
       region=${OPTARG}
       array=()

       for i in $(terraform workspace list| sed 's/*//g')
       do
           array+=("$i")
           echo "array[$i]"
       done
       echo "exiting"

       if [[ ! " ${array[*]} " =~ " $region " ]];
       then
           echo "Creating $region"
           # Create workspace if workspace doesn't exist
           terraform workspace new "$region"
           # Create workspace in all subdirectories
           #for d in ./*/ ; do (cd "$d" && terraform workspace new "$region");done
           for d in */;
           do(
               # ignore terra dirs and hidden dirs/files
               if [[ "$d" == *"terra"* ]] || [[ "$d" =~ ^\. ]]; then
                   continue
               fi
           # Create workspace in each module directory
           cd "$d" && terraform workspace new "$region"); done
       fi

       if [[ " ${array[*]} " =~ " $region " ]];
       then
           echo "Selecting $region"
           # Select the workspace
           terraform workspace select "$region"
           # Select workspace in all subdirectories
           #for d in ./*/ ; do (cd "$d" && terraform workspace select "$region");done
           for d in */;
            do(
                # ignore terra dirs and hidden dirs/files
                if [[ "$d" == *"terra"* ]] || [[ "$d" =~ ^\. ]]; then
                    continue
                fi
            # Select workspace in each module directory
            cd "$d" && terraform workspace select "$region"); done
       fi

       # Set region in terragrunt file
       hclq set 'locals.aws_region' "$region" < terragrunt.hcl | sponge terragrunt.hcl
       printf "Region Set to:\n"
       hclq get 'locals.aws_region' < terragrunt.hcl
       ;;
    h)
       echo "h stage"
       ;;
    *)
       usage
       exit
       ;;
esac
done

