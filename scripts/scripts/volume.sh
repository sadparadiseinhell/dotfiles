#!/bin/bash

MUTE="/usr/share/icons/Paper/22x22/panel/audio-volume-muted.svg"
LOW="/usr/share/icons/Paper/22x22/panel/audio-volume-low.svg"
MEDIUM="/usr/share/icons/Paper/22x22/panel/audio-volume-medium.svg"
HIGH="/usr/share/icons/Paper/22x22/panel/audio-volume-high.svg"

volume () {
	pamixer --get-volume
}

mute () {
	pamixer --get-mute
}

notification () {
    VOLUME=`volume`
    #bar=$(printf "$(seq -s "━" $(($VOLUME / 5)))" | sed 's/[0-9]//g')
	if [ "$VOLUME" -le 33 ]; then
		dunstify -t 2000 -r 2593 -u normal "volume: $VOLUME%" -i $LOW
	elif [ "$VOLUME" -le 66 ]; then
		dunstify -t 2000 -r 2593 -u normal "volume: $VOLUME%" -i $MEDIUM
	elif [ "$VOLUME" -le 100 ]; then
		dunstify -t 2000 -r 2593 -u normal "volume: $VOLUME%" -i $HIGH
	fi
}

case $1 in
	up)
	pamixer -u &> /dev/null
	pamixer -i 5 &> /dev/null
	notification
	;;
	down)
	pamixer -u &> /dev/null
	pamixer -d 5 &> /dev/null
	notification
	;;
    mute)
	pamixer -t > /dev/null
	if [ `mute` = 'true' ] ; then
	    dunstify -t 2000 -r 2593 -u normal "mute" -i $MUTE
	else
	    notification
	fi
	;;
esac