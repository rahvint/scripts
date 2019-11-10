#!/bin/bash
#
# This script will take a flat list of names and rename all matching files in another directory.
# match format: _<counter>.mkv / blah_00_disk1_1.mkv
# usage: rename_script <episode_list> <.mkv folder> <dest>
#
# Source file
file_path=$1
# directory to rename
rename_dir=$2
# destination
output_dir=$3

counter=0
while IFS= read -r line
do
  rename_file="$rename_dir"*_"$counter.mkv"
  echo $rename_file
  #mv -i $rename_file "$filepath$line.mkv"
  mv $rename_file "$output_dir$line.mkv"
  echo $counter
  counter=$((counter + 1))
done < "$file_path"
