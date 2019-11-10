#!/bin/bash

# This script will batch convert all ISO in a directory
# to MKV. 
# Arg1 = Target ISO Directory
# ARG2 = Target MKV Directory
# Usage = sudo sh convertalliso.sh ../ISO/ ../MKV/

echo "Usage sudo sh convertalliso.sh ../ISO/(origin) ../MKV/(dest)"

isodir=$1
mkvdir=$2
echo $isodir
echo $mkvdir
sudo mkdir ${mkvdir}working

#shopt -s nocaseglob

# Make everything in the directory Upper case and remove oddball characters.
echo 'Renaming all files in ' $isodir
sudo rename 's/_/ /g' $isodir*
sudo rename 'y/a-z/A-Z/' $isodir*

echo 'Renaming all files in ' $mkvdir
sudo rename 's/_/ /g' $mkvdir*
sudo rename 'y/a-z/A-Z/' $mkvdir*

for file in $isodir*.ISO; do
    filename="${file%.*}"
#    name=$(basename ${file})
#    name=${filename##*/}
#    echo $name
#    #filename=$(sed 's/[^A-Za-z0-9._-]//g' <<< "$filename")
    if [ -f $mkvdir"$(basename "${filename}")".MKV ]; then
       echo "Found" "$(basename "${filename}")".MKV
    else
       echo "Attempting to transcode " "$filename" " to MKV format"
       sudo split_isotomkv.sh "$filename".ISO $mkvdir | grep "Progress:" 
       echo "Transcoded: " "$filename"
    fi
done
sudo rmdir ${mkvdir}working

#shopt -u nocaseglob
