#!/bin/bash

PICS=$HOME/wallpapers/

if [ -n "$1" ]; then
	PICS=$1
fi

wal -t -i $PICS

sleep 0.10s

cd $HOME/build/dwm
make
make clean install
cd $HOME/build/st
make
make clean install
cd $HOME/build/dmenu
make
make clean install
cd $HOME/
pkill dunst &> /dev/null
sleep 1
dunst -conf $HOME/.config/dunst/dwm-dunstrc &
