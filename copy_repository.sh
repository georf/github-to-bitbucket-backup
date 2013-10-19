#!/bin/bash

name=$1
clone_url=$2
bitbucket_slug=$3


tmp_path="/tmp/$RANDOM"

mkdir $tmp_path
cd $tmp_path

git clone -q "$clone_url" github
git clone -q "ssh://git@bitbucket.org/georf/$bitbucket_slug.git" bitbucket

rm -rf github/.git
mv bitbucket/.git github/.git

cd github
git add -A .
git commit -am "Backup" > /dev/null
git push -q origin master

cd ~
rm -rf $tmp_path