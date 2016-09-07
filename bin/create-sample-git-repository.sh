#!/bin/bash -eu

mkdir ~/sample_remote
cd ~/sample_remote
git init --bare

mkdir ~/sample_local
cd ~/sample_local
git init
git config --local user.email "momonga@example.com"
git config --local user.name "Momonga"
echo 'sample' > sample.txt
git add sample.txt
git commit --no-edit -m'initial'
git checkout -b sample_merged
echo 'please merge' > sample.txt
git commit -a --no-edit -m'please merge'
git checkout master
git merge sample_merged --no-ff --no-edit -m'merge'
git checkout -b sample_unmerged
echo 'dont merge' > sample.txt
git commit -a --no-edit -m'dont merge'
git checkout master
git remote add origin ~/sample_remote
git push -u origin master
git checkout sample_merged
git push -u origin sample_merged
git checkout sample_unmerged
git push -u origin sample_unmerged
git checkout master
