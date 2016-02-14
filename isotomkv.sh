#!/bin/bash
# 
# Simple script to build .mkv from given ISO.
{
  echo ">> ISO found"
  echo ">> Setting the title..."
  
  filepath="$1"  

  title=$(makemkvcon -r info iso:$filepath)
  title=`echo "$title" | grep "CINFO:2,0"`
  title=${title:11}
  len=${#title}-1
  title=${title:0:$len}
  
  if [ -z "$title" ]; then
	echo ">> No title found"
	echo ">> Exiting"
	exit;
  else
	echo ">> Title set to: $title"
	echo ">> Starting .ISO to .MKV conversion..."	

   makemkvcon64 --minlength=4800 --cache=512 -r mkv --progress=-same iso:$filepath all $(dirname "$filepath") 
#  makemkvcon64 --minlength=4800 --cache=512 -r mkv --progress=-same iso:$filepath all $(dirname "$filepath") | grep '^PRGT:'
#	t = $(echo $LINE | awk '{ print $1 }' | cut -d, -f1)
#	echo $t
  
  mv -v $(dirname "$filepath")"/"*.mkv $(dirname "$filepath")"/mkv/"$title.mkv
    
  echo ">> $title.mkv created."
fi
} 