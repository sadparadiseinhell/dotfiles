#!/bin/sh

source $HOME/scripts/launcher.sh

CHOICE=$(printf 'Fullscreen\nFullscreen [Clip]\nArea\nArea [Clip]\nActive window' | $LAUNCHER -i -p 'Screenshot ')
SOUND='/usr/share/sounds/freedesktop/stereo/camera-shutter.oga'
SCROTDIR="$HOME/screenshots/"
NAME="$(date +%G_%m_%d_%T).png"
FILE="$HOME/scrot.png"

notification () {
	ACTION=$(dunstify -A O,action 'Screenshot saved' "$NAME" -i $FILE -t 2500) #& paplay $SOUND)
	if [[ $ACTION = 'O' ]]; then
		xdg-open $SCROTDIR 2> /dev/null && exit &
	fi
}

countdown() {
	if [[ -z $1 ]]; then
		v='3'
	else
		v=$1
	fi
	
	for (( i = $v; i > 0; i-- )); do
		dunstify -r 1338 -t 1050 "Screenshot" "Taking shot in $i seconds"
		sleep 1
	done
}

fullscreen () {
	countdown $1
	maim -u $FILE
	notification &
	paplay $SOUND
	mv $FILE $SCROTDIR/$NAME
}

fullscreen_clip () {
	FILE='/tmp/screenshot_clip.png'
	maim $FILE
	countdown
	xclip -selection clipboard -t image/png $FILE
	sleep 1
	notify-send -i $FILE "Screenshot copied to clipboard"
}

area () {
	sleep .5
	maim -s $FILE
	notification &
	paplay $SOUND
	mv $FILE $SCROTDIR/$NAME
}

area_clip () {
	sleep .5
	maim -s | xclip -selection clipboard -t image/png
	notify-send 'Screenshot copied to clipboard' -t 2500
}

active_window () {
	sleep 1
	maim -u -i $(xdotool getactivewindow) $FILE
	notify-send "Screenshot saved $NAME" -i $FILE -t 2500
	paplay $SOUND
	mv $FILE $SCROTDIR/$NAME
}

case $CHOICE in
	'Fullscreen')
		fullscreen $1
		;;
	'Fullscreen [Clip]')
		fullscreen_clip $1
		;;
	'Area')
		area
		;;
	'Area [Clip]')
		area_clip
		;;
	'Active window')
		active_window
		;;
esac
