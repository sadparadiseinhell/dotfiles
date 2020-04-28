#!/bin/sh

THEME=$(cat $HOME/.currtheme)

LIGHT=$(cat .colors/$THEME | grep -m 1 'color8' | awk '{print $2}')
DARK=$(cat .colors/$THEME | grep -m 1 'color0' | awk '{print $2}')
#DARKER=$(cat .colors/$THEME | grep 'darker' | awk '{print $3}')

FILE='/tmp/color.png'

time_of_day () {
	TIME=$(date +%H)
}

while true; do
	time_of_day
	case $TIME in
		0[6-9]|1[0-7])
			convert -size 32x32 xc:$LIGHT $FILE
			;;
		1[8-9]|2[0-3]|0[0-5])
			convert -size 32x32 xc:$DARK $FILE
			;;
		#2[2-3]|0[0-5])
		#	convert -size 32x32 xc:$DARKER $FILE
		#	;;
	esac
	feh --bg-tile $FILE
	sleep 600
done
