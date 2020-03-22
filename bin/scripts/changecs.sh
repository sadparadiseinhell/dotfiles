#!/bin/bash

PICS=$HOME/wallpapers/

if [ -n "$1" ]; then
	PICS=$1
fi

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

wal -q -t -i $PICS

sleep 1
dwm_rebuild &> /dev/null
bar_reload &> /dev/null
dmenu_rebuild &> /dev/null
st_rebuild &> /dev/null
dunst_reload &> /dev/null

wal --preview
