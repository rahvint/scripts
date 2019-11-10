#!/bin/bash

# A script to upgrade MKV so I don't have to do it all the time
# by hand.

# usage ./upgrade_mkv.sh <new version"
# sh ./upgrade_mkv.sh 1.10.6

# Query the current version from the website.
latest_version="$(curl --silent "http://www.makemkv.com/download/" 2>&1 | egrep -o 'MakeMKV ([^ ]*) for' | sed 's/MakeMKV //' | sed 's/ for//' | uniq)"
echo "Latest version is : "$latest_version"

installed_version="$(makemkvcon info 2>&1 | egrep -o 'MakeMKV ([^ ]*)' | sed 's/MakeMKV v//' )"
echo "Installed version is : "$installed_version"

echo "y (Install Latest), q(Quit), l(Legacy Install)"

version=""
legacy="yes"

read input
echo $input

if [ $input = "q" && $# -ne 0 ]; then
  exit 1
fi

if [ $input = "y" ]; then
   legacy="no"
   version=$latest_version
   echo $version
else
   echo $input
   echo "What version?"
   read version
fi

echo "Downloading the new version ${version}"

echo "Get /makemkv-bin-"$version".tar.gz"
if [ $legacy = "no" ]; then
  sudo wget http://www.makemkv.com/download/makemkv-bin-"$version".tar.gz
else
  sudo wget http://www.makemkv.com/download/old/makemkv-bin-"$version".tar.gz
fi

echo "Get /makemkv-oss-"$version".tar.gz"
if [ $legacy = "no" ]; then
  sudo wget http://www.makemkv.com/download/makemkv-oss-"$version".tar.gz
else
  sudo wget http://www.makemkv.com/download/old/makemkv-oss-"$version".tar.gz
fi


echo "Unzipping...."
sudo tar -xvzf makemkv-bin-"$version".tar.gz
sudo tar -xvzf makemkv-oss-"$version".tar.gz

echo "Checking/Getting dependencies...."
sudo apt-get install build-essential pkg-config libc6-dev libssl-dev libexpat1-dev libavcodec-dev libgl1-mesa-dev libqt4-dev

cd ./makemkv-oss-"$version"

echo "Configuring install...."
sudo ./configure

echo "Making oss..."
sudo make

echo "Installing oss..."
sudo make install

cd ../makemkv-bin-"$version"

echo "Making bin...."
sudo make

sudo mkdir tmp
echo -n accepted >tmp/eula_accepted

echo "Installing bin..."
sudo make install

echo "Cleaning up..."
sudo rm -rf makemkv-bin-"$version".*
sudo rm -rf makemkv-oss-"$version".*

sudo rm makemkv-bin-"$version".tar.gz
sudo rm makemkv-oss-"$version".tar.gz

sudo rm -rf tmp
