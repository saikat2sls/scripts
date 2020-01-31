#!/bin/sh

#This script is to checkout the api-specifications repo to an internal folder
#the branch name of server-code is appended wih _SPEC for the api-specifications branch
if [ "$#" -lt 1 ] ; then
  echo "Usage : api-specs-checkout.sh <spec-release-branch> "
  echo "        e.g. api-specs-checkout.sh r6.0"
  exit 1
fi

script=`realpath $0`
script_dir=`dirname $script`
#echo $scriptpath
git_root_dir=$script_dir/../../..
git_repo="https://github.mv.usa.alcatel.com/Documentation/api-specifications.git"
api_spec_dir="v5"
spec_branch=$1
current_branch_name=`git symbolic-ref --short -q HEAD`
spec_branch_name="${current_branch_name}_SPEC"
echo $spec_branch_name

#echo $script_dir
#echo "Trying to copy specs from $git_repo"

while [ "$#" -gt 1 ]; do
  #specs_checkout_dir_path=$git_root_dir/..
  specs_checkout_dir_path="$script_dir/src/main/resources/api-specifications"
  echo $spec_checkout_dir_path
  if [ ! -d "$specs_checkout_dir_path/$api_spec_dir" ] ; then
    echo "Could not find $specs_checkout_dir_path/$api_spec_dir, will create and clone fresh"
    #mkdir $specs_checkout_dir
    cd $specs_checkout_dir_path
    echo "Trying to copy specs from $git_repo to $specs_checkout_dir_path/$api_spec_dir"
    git clone $git_repo $api_spec_dir
    #exit 1
  else
    echo "api-specification directoy exists ..ENSURE NO UNCOMMITTED CHANGES ARE PRESENT!!" 
  fi
  
  cd  $specs_checkout_dir_path/$api_spec_dir
  echo "Changing api-specification to branch $spec_branch"
  git checkout $spec_branch
  git pull
  output=$(eval "git rev-parse --verify --quiet $spec_branch_name")
  #echo $output
  if [ -z "$output" ]
  then	  	  
     echo "$spec_branch_name branch created for api-spec changes"	  
     git checkout -b $spec_branch_name
  else
     echo "$spec_branch_name reused for api-spec changes"	  
     git checkout $spec_branch_name
  fi     
  shift 2
done
