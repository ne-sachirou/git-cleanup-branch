#!/bin/bash -eu

mkdir ~/sample_local
cd ~/sample_local
git init
echo 'sample' > sample.txt
git add sample.txt
git commit --no-edit -m'initial'
git checkout -b sample_merged
echo 'please marge' > sample.txt
git commit -a --no-edit -m'please marge'
git checkout master
git merge sample_merged --no-ff --no-edit -m'merge'
git checkout -b sample_unmerged
echo 'dont marge' > sample.txt
git commit -a --no-edit -m'dont marge'
git checkout master

mkdir ~/sample_remote
cd ~/sample_remote
git init --bare

cd ~/sample_local
git remote add origin ~/sample_remote
git push -u origin master
git checkout sample_merged
git push -u origin sample_merged
git checkout sample_unmerged
git push -u origin sample_unmerged
git checkout master

true
