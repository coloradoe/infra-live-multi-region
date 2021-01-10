#!/bin/bash

while getopts r:h:*: flag
do
   case "${flag}" in
      r)
         region=${OPTARG}
         array=()
         array1=()

         for i in $(terraform workspace list| sed 's/*//g');
         do(
            array+=("$i")
            echo "array[$i]"
         );done

         if [[ ! " ${array[*]} " =~ " $region " ]];
         then
            $(terraform workspace new $region)
         fi
         if [[ " ${array[*]} " =~ " $region " ]];
         then
            $(terraform workspace select $region)
         fi

         for j in */;
         do(
            if [[ "$j" == *"terra"* ]] || [[ "$j" =~ ^\. ]]; then
               continue
            fi
            echo "$j"
            for k in $(terraform workspace list| sed 's/*//g');
            do(
               array1+=("$k")
               echo "array1[$k]"
               );done
         );done

         if [[ ! " ${array1[*]} " =~ " $region " ]];
         then
            $(terraform workspace new $region)
         fi
         if [[ " ${array1[*]} " =~ " $region " ]];
         then
            $(terraform workspace select $region)
         fi
         ;;
esac
done
