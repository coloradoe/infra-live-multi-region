#!/bin/bash

while getopts r:h:*: flag
do
   case "${flag}" in
      r)
         region=${OPTARG}
         array=()
         array1=()

         for i in $(terraform workspace list| sed 's/*//g');
         do
            array+=("$i")
            echo "array[$i]"
         done

         if [[ ! " ${array[*]} " =~ " $region " ]];
         then
            echo "create from root"
            terraform workspace new $region
         fi
         if [[ " ${array[*]} " =~ " $region " ]];
         then
            echo "select from root"
            terraform workspace select $region
         fi

         for j in */;
         do(
            if [[ "$j" == *"terra"* ]] || [[ "$j" =~ ^\. ]]; then
               continue
            fi
            echo "$j"
            cd $j
            pwd
            for k in $(terraform workspace list| sed 's/*//g');
            do
               array1+=("$k")
               echo "array1[$k]"
            done

            if [[ ! " ${array1[*]} " =~ " $region " ]];
            then
               terraform workspace new $region
            fi
            if [[ " ${array1[*]} " =~ " $region " ]];
            then
               terraform workspace select $region
            fi
            cd ../
            pwd
         );done

         # Set region in terragrunt file
         hclq set 'locals.aws_region' "$region" < terragrunt.hcl | sponge terragrunt.hcl
         printf "Region Set to:\n"
         hclq get 'locals.aws_region' < terragrunt.hcl
         ;;
esac
done
