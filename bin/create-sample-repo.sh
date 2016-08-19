#!/bin/bash

mkdir sample_repo
cd sample_repo
git init
echo 'sample' > sample.txt
git commit -a -m'initial'
git checkout -b sample_merged
echo 'please marge' > sample.txt
git commit -a -m'please marge'
git chockout master
git merge sample_merge -m'merge'
git checkout -b sample_unmerged
echo 'dont marge' > sample.txt
git commit -a -m'dont marge'
git chockout master
