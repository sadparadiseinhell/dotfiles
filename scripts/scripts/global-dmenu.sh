#!/bin/bash

chosen=$(echo -e "power\nscreenshot\nset wallpaper\nto-do\ntimer\nvideo\ncalculator\nupdates" | dmenu -p "menus  ")

case $chosen in
	power)
		$HOME/scripts/power-menu.sh ;;
	screen*)
		$HOME/scripts/screenshot-menu.sh ;;
	set*)
		$HOME/scripts/setwall.sh ;;
	to-do)
		$HOME/scripts/todo.sh ;;
	timer)
		$HOME/scripts/tt.sh ;;
	video)
		$HOME/scripts/video.sh ;;
	calc*)
		echo ' ' | grep 0 | dmenu -p 'enter an example  ' | bc | dmenu -p 'result  ' ;;
	updates)
		$HOME/scripts/checkupdates.sh ;;
esac