#!/bin/bash
#
# This script will find the longest title on an ISO and make a single
# .mkv out of it.
#
#
  echo ">> ISO found"
  echo ">> Setting the title..."
  filepath=$1
  savedir=$2
  echo $filepath
  echo $savedir

  title=${filepath##*/}
  title=${title%.ISO}
  echo $title
  if [ -z "$title" ]; then
        echo ">> No title found"
        echo ">> Exiting"
        exit;
  else
        echo ">> Title set to: $title"
        echo ">> Starting .ISO to .MKV conversion..."

   longestTrack=$(makemkvcon -r info iso:$filepath | grep cell | awk '{ print $$
   echo "Using Track size: $longestTrack"

   sudo mkdir ${savedir}/${title}
   sudo makemkvcon --minlength="$longestTrack" --cache=512 -r mkv --progress=-s$

   sudo mv -v ${savedir}/${title}/*.mkv ${savedir}${title}.MKV
   sudo rmdir ${savedir}/${title}
   echo ">> $title.MKV created."
fi