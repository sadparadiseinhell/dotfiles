#!/bin/bash

WALLDIR="$HOME/wallpapers"
chosen=$(ls $WALLDIR | dmenu -p "select wallpaper  " )

dwmrebuild () {
	cd $HOME/build/dwm
	make &> /dev/null
	make clean install &> /dev/null
	killall dwm
	cd $HOME
}

strebuild () {
	cd $HOME/build/st
	make &> /dev/null
	make clean install &> /dev/null
	cd $HOME
}

dmenurebuild () {
	cd $HOME/build/dmenu
	make &> /dev/null
	make clean install &> /dev/null
	cd $HOME
}

tabbedrebuild () {
	cd $HOME/build/tabbed
	make &> /dev/null
	make clean install &> /dev/null
	cd $HOME
}

dunstreload () {
	killall dunst &> /dev/null
	killall dunst &> /dev/null
	dunst -conf $HOME/.config/dunst/dwm-dunstrc &
}

if [[ "$chosen" ]]; then
	wal -q -t -i $WALLDIR/$chosen
	dmenurebuild
	dwmrebuild
	strebuild
	tabbedrebuild
	dunstreload
	sleep 1
	notify-send "$chosen is set as wallpaper" -t 3200
fi
