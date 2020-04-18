#!/bin/sh

THEME=$(cat $HOME/.curtheme)

LIGHT=$(cat .colors/$THEME-colors | grep 'light' | awk '{print $3}')
DARK=$(cat .colors/$THEME-colors | grep -m 1 'dark' | awk '{print $3}')
DARKER=$(cat .colors/$THEME-colors | grep 'darker' | awk '{print $3}')

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
		1[8-9]|2[0-1])
			convert -size 32x32 xc:$DARK $FILE
			;;
		2[2-3]|0[0-5])
			convert -size 32x32 xc:$DARKER $FILE
			;;
	esac
	feh --bg-tile $FILE
	sleep 600
done
