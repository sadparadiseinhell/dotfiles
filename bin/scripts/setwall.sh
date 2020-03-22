#!/bin/bash

WALLDIR="$HOME/wallpapers"
CHOSEN=$(ls $WALLDIR | dmenu -p "select wallpaper  " )

dwm_rebuild () {
	cd $HOME/build/dwm
	make &> /dev/null
	make clean install &> /dev/null
	killall dwm
	cd $HOME
}

st_rebuild () {
	cd $HOME/build/st
	make &> /dev/null
	make clean install &> /dev/null
	cd $HOME
}

dmenu_rebuild () {
	cd $HOME/build/dmenu
	make &> /dev/null
	make clean install &> /dev/null
	cd $HOME
}

dunst_reload () {
	killall dunst &> /dev/null
	killall dunst &> /dev/null
	dunst -conf $HOME/.config/dunst/dwm-dunstrc &
}

bar_reload () {
	killall dwm-bar.sh &> /dev/null
	$HOME/scripts/dwm-bar.sh
}

if [[ "$CHOSEN" ]]; then
	wal -q -t -i $WALLDIR/$CHOSEN
	dwm_rebuild
	bar_reload
	dunst_reload
	sleep 1
	notify-send "$CHOSEN is set as wallpaper" -t 3200
	st_rebuild
	dmenu_rebuild
fi
