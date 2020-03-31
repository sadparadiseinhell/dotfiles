#!/bin/bash

FILE='/tmp/color.png'

time_of_day () {
	TIME=$(date +%H)
}

while true; do
	time_of_day
	case $TIME in
		0[6-9]|1[0-7])
			convert -size 32x32 xc:#D8DEE9 $FILE
			;;
		1[8-9]|2[0-1])
			convert -size 32x32 xc:#3B4252 $FILE
			;;
		2[2-3]|0[0-5])
			convert -size 32x32 xc:#2E3440 $FILE
			;;
		*)
			notify-send -u critical 'wallpaper.sh:' 'error'
			;;
	esac
	feh --bg-tile $FILE
	sleep 600
done
