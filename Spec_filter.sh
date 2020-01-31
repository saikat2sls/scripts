#!/bin/bash


if [ "$#" -lt 2 ] ; then
  echo "Usage : filter-specs.sh <spec-directory> [<atribute> <attribute-value>] ..."
  echo "sample 1: ./Spec_filter filter-specs api-specifications required true"
  echo "sample 2: ./Spec_filter.sh . required true read_only true" 
  exit 1
fi

#install jq if not installed
jq_dir=`which jq`
if [ -z "$jq_dir" ]
    then
	sudo apt-get update
        sudo apt-get install jq
fi

spec_dir=$1
if [ "$1" = "." ]
  then
    spec_dir="$PWD"
fi  

jq_command="jq '.attributes[] | select(1"
while [ "$#" -gt 2 ]; do
      jq_command+=" and (.$2 == $3)"
      shift 2
done
jq_command+=") | .name'"
#echo $jq_command

eval "$jq_command domain.spec"

#go through the spec files and match the attribute pattern
for spec in "$spec_dir"/*
do
  if [[ "$spec" == *".spec" ]]
    then	
      #echo "$spec"
      #jq '.attributes[] | select(.required == true) | .name' $spec
      output=$(eval "$jq_command $spec")
      if [ ! -z "$output" ]
      then
	      echo "File: $spec"
	      echo "$output"
      fi   
  fi
done
