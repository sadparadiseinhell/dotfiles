#!/bin/bash

WALLDIR="$HOME/wallpapers"
CHOSEN=$(ls $WALLDIR | dmenu -p "select wallpaper " )

if [[ "$CHOSEN" ]]; then
	feh --bg-fill $WALLDIR/$CHOSEN
	notify-send "$CHOSEN is set as wallpaper" -t 3200
fi
