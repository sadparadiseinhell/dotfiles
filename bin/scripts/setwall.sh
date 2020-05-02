#!/bin/sh

source $HOME/scripts/launcher.sh

WALLDIR="$HOME/wallpapers"
CHOSEN=$(ls $WALLDIR | $LAUNCHER -p "select wallpaper " )

if [[ "$CHOSEN" ]]; then
	feh --bg-fill $WALLDIR/$CHOSEN
	notify-send "$CHOSEN set as wallpaper" -t 3200
	exec scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
fi
