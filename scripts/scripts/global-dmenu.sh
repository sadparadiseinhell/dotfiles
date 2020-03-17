#!/bin/bash

chosen=$(echo -e "power\nscreenshot\nset wallpaper\nto-do\ntimer\nvideo" | dmenu -p "menus  ")
if [[ $chosen = 'power' ]]; then
	$HOME/scripts/power-menu.sh
elif [[ $chosen = 'screenshot' ]]; then
	$HOME/scripts/screenshot-menu.sh
elif [[ $chosen = 'set wallpaper' ]]; then
	$HOME/scripts/setwall.sh
elif [[ $chosen = 'to-do' ]]; then
	$HOME/scripts/todo.sh
elif [[ $chosen = 'timer' ]]; then
	$HOME/scripts/tt.sh
elif [[ $chosen = 'video' ]]; then
	$HOME/scripts/video.sh
fi