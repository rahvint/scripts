#!/bin/bash

SCRIPT=`basename "$0"`
MKVEXTRACT=`which mkvextract`
MKVMERGE=`which mkvmerge`

outdir="./"
series=00

if [ "$1" == "" ] || [ "$1" == "--help" ] || [ "$1" == "-h" ]; then
    echo "$SCRIPT: Give MKV to chapter-split as an argument, optionally an output dir, and optionally series number"
    echo "$SCRIPT: e.g.:  ripped_season_03.mkv ./ 3"
    echo "$SCRIPT: e.g.:  ripped_music_videos.mkv ~/Music_Clips/"
    exit 1
fi

if [ ! -f "$1" ]; then
    echo "$SCRIPT: MKV file not found [$1]"
    exit 1
fi

if [ "$2" != "" ]; then
   outdir="$2"
   if [ ! -d "$outdir" ] || [ ! -x "$outdir" ] || [ ! -w "$outdir" ]; then
       echo "$SCRIPT: The output directory has a problem ($outdir)"
       echo "$SCRIPT: Not existing, not writable, not a dir, etc."
       exit 1
   fi
fi

if [ "$3" != "" ]; then
    series="$3"

    ### Check it's 2 digits, or make it so
    if [ ${#series} -gt 2 ]; then
        series=`echo $series | cut -b 1-2`
    elif [ ${#series} -lt 2 ]; then
        series="0$series"
    fi

    echo "$SCRIPT: Series number is [$series]"
fi

if [ "$MKVEXTRACT" == "" ] || [ ! -x "$MKVEXTRACT" ]; then
    echo "$SCRIPT: 'mkvextract' seems to be missing"
    echo "Is MKVToolsNix Installed?"
    echo "sudo apt-get install mkvtoolsnix"
    exit 2
fi

if [ "$MKVMERGE" == "" ] || [ ! -x "$MKVMERGE" ]; then
    echo "$SCRIPT: 'mkvmerge' seems to be missing"
    echo "Is MKVToolsNix Installed?"
    echo "sudo apt-get install mkvtoolsnix"
    exit 2
fi

infile="$1"
timecodes=`sudo "$MKVEXTRACT" chapters -s "${infile}"|grep "CHAPTER[0-9][0-9]="|sed '1,1d;:a;N;$!ba;s/CHAPTER[0-9][0-9]\=//g;s/\n/,/g'`

if [ "$series" == "00" ]; then
    # no series number
    "$MKVMERGE" --split timecodes:"${timecodes}" "${infile}" -o "${outdir}/${infile%.mkv}_%01d.mkv"
else
    "$MKVMERGE" --split timecodes:"${timecodes}" "${infile}" -o "${outdir}/${infile%.mkv} S${series}E%01d.mkv"
fi
