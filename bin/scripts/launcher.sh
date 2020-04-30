#!/bin/sh

if [[ $DISPLAY && ! $WM ]]; then
	ID="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
	WM="$(xprop -id ${ID##* } -notype -len 100 -f _NET_WM_NAME 8t)"
	WM=${WM/*WM_NAME = } WM=${WM/\"} WM=${WM/\"*} WM=${WM,,}
fi

case $WM in
	'openbox')
		LAUNCHER="rofi -dmenu -theme slate"
		;;
	'dwm')
		LAUNCHER="dmenu"
		;;
	*)
		LAUNCHER="dmenu"
		;;
esac
