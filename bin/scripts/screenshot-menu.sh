#!/bin/bash

SCROTDIR=$HOME/screenshots/
NAME="$(date +%G_%m_%d_%T)_scrot.png"
SOUND="/usr/share/sounds/freedesktop/stereo/camera-shutter.oga"

chosen=$(echo -e 'fullscreen\narea\narea to clipboard\nactive window' | dmenu -p 'scrot menu ')
if [[ $chosen = 'fullscreen' ]]; then
	sleep 1
	maim "$HOME/scrot.png"
	notify-send 'screenshot saved!' -i $HOME/scrot.png -t 2500
	paplay $SOUND
	mv $HOME/scrot.png $SCROTDIR/$NAME
elif [[ $chosen = 'area' ]]; then
	maim -s $HOME/scrot.png
	notify-send 'screenshot saved!' -i $HOME/scrot.png -t 2500
	paplay $SOUND
	mv $HOME/scrot.png $SCROTDIR/$NAME
elif [[ $chosen = 'area to clipboard' ]]; then
	maim -s | xclip -selection clipboard -t image/png
	notify-send 'screenshot copied to clipboard' -t 2500
elif [[ $chosen = 'active window' ]]; then
	sleep 1
	maim -i $(xdotool getactivewindow) "$HOME/scrot.png"
	notify-send 'screenshot saved!' -i $HOME/scrot.png -t 2500
	paplay $SOUND
	mv $HOME/scrot.png $SCROTDIR/$NAME
fi
