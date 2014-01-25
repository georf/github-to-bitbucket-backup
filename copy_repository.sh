#!/bin/bash

bitbucket_username=$1
clone_url=$2
bitbucket_slug=$3


tmp_path="/tmp/$RANDOM"

mkdir $tmp_path || exit 2
cd $tmp_path || exit 2

git clone "$clone_url" github || exit 2
cd github || exit 2

git remote add -f bitbucket "ssh://git@bitbucket.org/$bitbucket_username/$bitbucket_slug.git" || exit 2
git push bitbucket '*:*' || exit 2
git push bitbucket --all || exit 2
git push bitbucket --tags || exit 2

cd ~ || exit 2
rm -rf $tmp_path || exit 2
