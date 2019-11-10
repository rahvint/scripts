#!/bin/bash
#
# Simple script to build .mkv from given ISO.
#
  echo ">> ISO found"
  echo ">> Setting the title..."
  filepath=$1
  savedir=$2
  echo $filepath
  echo $savedir

# 7/21/16 - This line is what was here before, but issues with some video
# having title on track 0.
#   track=$(makemkvcon -r info iso:$filepath | grep 'title0' | head -1 | cut -c 7)

# Find the track # with GB, probably an issue with more than one titles.
#   track=$(makemkvcon -r info iso:$filepath | grep ' GB' | head -1 | cut -c 7)

#  echo $title
#  track='echo "$title" | grep 'title0' | head -1 | cut -c 7

#   echo "Using Track: $longestTrack"
#  title=${title:11}
#  len=${#title}-1
#  title=${title:0:$len}
#  title=${title^^}
#  title=${title// /_}

#  title="${title//:/}"
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
        echo "$savedir $title"

   longestTrack=$(makemkvcon -r info iso:$filepath | grep cell | awk '{ print $7 }' | tr -d '\)\",\"Title' | sort -nr | head -n1 | awk -F: '{print ($1 * 3600) + ($2 * 60) + $3}')
   echo "Using Track size: $longestTrack"

   sudo mkdir $title

   sudo makemkvcon --minlength="$longestTrack" --cache=512 -r mkv --progress=-same iso:$filepath all ${savedir}/$title
#  makemkvcon64 --minlength=4800 --cache=512 -r mkv --progress=-same iso:$filepath all $(dirname "$filepath") | grep '^PRGT:'
#	t = $(echo $LINE | awk '{ print $1 }' | cut -d, -f1)
#	echo $t

#   test=${savedir}/${title}
#   echo $test
# put in a loop to spool thru all .mkv and title them _1, _2
#  sudo mv -v ${savedir}working/*.mkv ${savedir}${title}.MKV
#  sudo rm ${savedir}working/*.mkv
  echo ">> $title.MKV created."
fi
