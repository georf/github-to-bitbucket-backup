#!/bin/bash

bitbucket_username=$1
clone_url=$2
bitbucket_slug=$3


tmp_path="/tmp/$RANDOM"

mkdir $tmp_path
cd $tmp_path

git clone "$clone_url" github
cd github

git remote add -f bitbucket "ssh://git@bitbucket.org/$bitbucket_username/$bitbucket_slug.git"
git push bitbucket '*:*'
git push bitbucket --all
git push bitbucket --tags

cd ~
rm -rf $tmp_path