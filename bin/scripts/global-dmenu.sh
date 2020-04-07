#!/bin/bash

chosen=$(echo -e 'power\nscreenshot\ntheme\nset wallpaper\nto-do\ntimer\nvideo\ncalculator\nupdates\nscreencast' | dmenu -p 'menu ')

case $chosen in
	power)
		$HOME/scripts/power-menu.sh ;;
	screenshot)
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
		$HOME/scripts/tinycalculator.sh ;;
	updates)
		$HOME/scripts/checkupdates.sh ;;
	screencast)
		$HOME/scripts/screencast.sh ;;
	theme)
		$HOME/scripts/settheme.sh ;;
esac