#!/bin/bash

chosen=$(echo -e "power\nscreenshot\nset wallpaper\nto-do\ntimer\nvideo\ncalculator\nupdates\nscreencast\ntranslator" | dmenu -p "menu  ")

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
		echo | grep 0 | dmenu -p 'enter an example  ' | bc | dmenu -p 'result  ' | xclip -selection c ;;
	updates)
		$HOME/scripts/checkupdates.sh ;;
	screencast)
		$HOME/scripts/screencast.sh ;;
	translator)
		$HOME/scripts/translator.sh ;;
esac