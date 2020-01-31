#!/bin/sh

if [ "$#" -lt 2 ] ; then
  echo "Usage : api-specs-checkout.sh <spec-release-branch> <spec-private-branch-name> "
  echo "        e.g. api-specs-checkout.sh r6.0 saikat_spec_test"
  exit 1
fi

script_dir=`dirname "$0"`
git_root_dir=$script_dir/../../..
git_repo="https://github.mv.usa.alcatel.com/Documentation/api-specifications.git"
api_spec_dir="Spec"
spec_branch=$1
branch_name=$2

#cd $git_root_dir
echo $script_dir
echo "Trying to copy specs from $git_repo"

while [ "$#" -gt 1 ]; do
  specs_checkout_dir_path=$git_root_dir/..
  if [ ! -d "$specs_checkout_dir_path/$api_spec_dir" ] ; then
    echo "Could not find $specs_checkout_dir, will create and clone fresh"
    #mkdir $specs_checkout_dir
    cd $specs_checkout_dir_path
    git clone $git_repo $api_spec_dir
    #exit 1
  else
    echo "api-specification directoy exists ..ensure no uncommitted changes are present!!" 
    #cd $specs_checkout_dir
  fi
  
  cd  $specs_checkout_dir_path/$api_spec_dir
  echo "Changing api-specification to branch $spec_branch"
  git checkout $spec_branch
  git pull
  output=$(eval "git rev-parse --verify --quiet $branch_name")
  #echo $output
  if [ -z "$output" ]
  then	  
     git checkout -b $branch_name
  else
     git checkout $branch_name
  fi     
  shift 2
done
