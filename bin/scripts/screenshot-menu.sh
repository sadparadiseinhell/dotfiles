#!/bin/bash

CHOICE=$(echo -e 'fullscreen\narea\narea to clipboard\nactive window' | dmenu -p 'scrot menu ')
SOUND='/usr/share/sounds/freedesktop/stereo/camera-shutter.oga'
SCROTDIR="$HOME/screenshots/"
NAME="$(date +%G_%m_%d_%T)_scrot.png"
FILE="$HOME/scrot.png"

case $CHOICE in
	full*)
		sleep 1
		maim $FILE
		notify-send 'screenshot saved!' -i $FILE -t 2500
		paplay $SOUND
		mv $FILE $SCROTDIR/$NAME
		;;
	area)
		sleep .5
		maim -s $FILE
		notify-send 'screenshot saved!' -i $FILE -t 2500
		paplay $SOUND
		mv $FILE $SCROTDIR/$NAME
		;;
	'area to clipboard')
		sleep .5
		maim -s | xclip -selection clipboard -t image/png
		notify-send 'screenshot copied to clipboard' -t 2500	
		;;
	active*)
		sleep 1
		maim -i $(xdotool getactivewindow) $FILE
		notify-send 'screenshot saved!' -i $FILE -t 2500
		paplay $SOUND
		mv $FILE $SCROTDIR/$NAME
		;;
esac
