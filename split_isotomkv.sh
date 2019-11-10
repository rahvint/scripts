#!/bin/bash
#
# This script will split an iso into various chapters
# .mkv out of it.
# Currently it is set to cut anything less than 5 minutes in length.
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

#   longestTrack=$(makemkvcon -r info iso:"$filepath" | grep cell | awk '{ print $7 }' | tr -d '\)\",\"Title' | grep -o '[0-9]:[0-9][0-9]:[0-9][0-9]' | sort -nr | head -n1 | awk -F: '{print ($1 * 3600) + ($2 * 60) + $3}')
#   echo "Using Track size: $longestTrack"

   sudo mkdir "${savedir}/${title}"
#  sudo makemkvcon --minlength="$longestTrack" --cache=512 -r mkv --progress=-same iso:$filepath all ${savedir}/${title} | grep '^PRGV:' | awk -F, '{one+=$2+1;two+=$3+1;printf "Progress:(%d%)\r", one/two*100;}'
   sudo makemkvcon --minlength=300 --profile=/home/rahvin/.MakeMKV/perfect_profile.xml --cache=512 -r mkv --progress=-same iso:"$filepath" all "${savedir}/${title}" | grep '^PRGV:' | awk -F, '{one+=$2+1;two+=$3+1;printf "Progress:(%d%)\r", one/two*100;}'
   echo ">> $title.MKV created"

#   ls -Q "${savedir}/${title}" | head -1 | sudo xargs -i mv -v "${savedir}/${title}"/{} "${savedir}/${title}".MKV

#   sudo mv -v "${savedir}/${title}/"*_t00.mkv "${savedir}/${title}".MKV
#   sudo mv -v ${savedir}/${title}/title_t00.mkv ${savedir}/${title}/${title}.MKV
#   sudo rm -rf "${savedir}/${title}"
#   echo ">> $title.MKV moved to ${savedir}/${title}"
fi
