#!/bin/sh

source $HOME/scripts/launcher.sh

MAIN=$(echo -e 'power\nscreenshot\nmusic\ntheme\nto-do\nvideo\nupdates\nother' | $LAUNCHER -p 'menu ')

second_menu () {
	SECOND=$(echo -e 'run\napps\nset wallpaper\nscreencast\ntimer\ncalculator' | sort | $LAUNCHER -p 'menu ')
	case $SECOND in
		set*)
			$HOME/scripts/setwall.sh
			;;
		screencast)
			$HOME/scripts/screencast.sh
			;;
		timer)
			$HOME/scripts/tinytimer.sh
			;;
		calc*)
			$HOME/scripts/tinycalculator.sh
			;;
		apps)
			if [[ $LAUNCHER = rofi* ]]; then
				rofi -show drun -theme slate
			else
				dmenu_run
			fi
			;;
		run)
			if [[ $LAUNCHER = rofi* ]]; then
				rofi -show run -theme slate
			else
				dmenu_run
			fi
			;;
	esac
}

case $MAIN in
	power)
		$HOME/scripts/power-menu.sh
		;;
	screenshot)
		$HOME/scripts/scrot-menu.sh
		;;
	music)
		$HOME/scripts/mpd-menu.sh
		;;
	theme)
		$HOME/scripts/theme.sh
		;;
	to-do)
		$HOME/scripts/todo.sh
		;;
	video)
		$HOME/scripts/video.sh
		;;
	updates)
		$HOME/scripts/checkupdates.sh
		;;
	other)
		second_menu
		;;
esac