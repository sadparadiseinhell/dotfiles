#!/bin/sh

source $HOME/scripts/launcher.sh

MAIN=$(echo -e 'Power\nScreenshot\nMusic\nSet wallpaper\nTo-Do\nVideo\nUpdates\nOther' | $LAUNCHER -i -p 'Menu ')

second_menu () {
	SECOND=$(echo -e 'Run\nApps\nTheme\nScreencast\nTimer\nCalculator' | sort | $LAUNCHER -i -p 'Menu ')
	case $SECOND in
		Theme)
			$HOME/scripts/theme.sh
			;;
		Screencast)
			$HOME/scripts/screencast.sh
			;;
		Timer)
			$HOME/scripts/tinytimer.sh
			;;
		Calc*)
			$HOME/scripts/tinycalculator.sh
			;;
		Apps)
			if [[ $LAUNCHER = rofi* ]]; then
				rofi -show drun -theme slate
			else
				dmenu_run
			fi
			;;
		Run)
			if [[ $LAUNCHER = rofi* ]]; then
				rofi -show run -theme slate
			else
				dmenu_run
			fi
			;;
	esac
}

case $MAIN in
	Power)
		$HOME/scripts/power-menu.sh
		;;
	Screenshot)
		$HOME/scripts/scrot-menu.sh
		;;
	Music)
		$HOME/scripts/mpd-menu.sh
		;;
	Set*)
		$HOME/scripts/setwall.sh
		;;
	To-Do)
		$HOME/scripts/todo.sh
		;;
	Video)
		$HOME/scripts/video.sh
		;;
	Updates)
		$HOME/scripts/checkupdates.sh
		;;
	Other)
		second_menu
		;;
esac