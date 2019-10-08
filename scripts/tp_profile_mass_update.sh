#!/bin/sh
repo_dir="$(dirname $0)/.."
. "${repo_dir}/scripts/functions"
cd $repo_dir
while read line
do
  a=$(echo $line | cut -f 1 -d ' ')
  b=$(echo $line | cut -f 2 -d ' ')
  rm -f "manifests/${a}.pp"
  rm -f "spec/classes/${a}_spec.rb"
  scripts/tp_profile.generate.sh $a $b
done < scripts/tp_profile_mass_update.txt
