#!/bin/sh

source $HOME/scripts/launcher.sh

SOUND='/usr/share/sounds/freedesktop/stereo/camera-shutter.oga'
SCROTDIR="$HOME/screenshots/"
NAME="$(date +%G_%m_%d_%T).png"
FILE="/tmp/scrot.png"
ROFIMENU=$LAUNCHER
ROFIAPPLET="rofi -theme scrot-menu.rasi"

notification () {
	action=$(dunstify -A O,action 'Screenshot saved' "$NAME" -i $FILE -t 2500)
	[[ $action = 'O' ]] && xdg-open $SCROTDIR 2> /dev/null && exit &
}

countdown () {
	if [[ -z $2 ]]; then
		t='3'
	else
		t=$2
	fi
	
	for (( i = $t; i > 0; i-- )); do
		dunstify -r 1338 -t 1050 "Screenshot" "Taking shot in $i seconds"
		sleep 1
	done
}

menu () {
	choice=$(printf 'Fullscreen\nFullscreen [Clip]\nArea\nArea [Clip]\nActive window' | $LAUNCHER -i -l 5 -p 'Screenshot ')
	
	fullscreen () {
		countdown $@
		maim -u $FILE
		notification &
		paplay $SOUND
		mv $FILE $SCROTDIR/$NAME
	}
	
	fullscreen_clip () {
		sleep .5
		maim -u $FILE
		xclip -selection clipboard -t image/png < $FILE
		notify-send -i $FILE "Screenshot copied to clipboard"
	}
	
	area () {
		sleep .5
		maim -s $FILE
		notification &
		paplay $SOUND
		mv $FILE $SCROTDIR/$NAME
	}
	
	area_clip () {
		sleep .5
		maim -s $FILE
		xclip -selection clipboard -t image/png < $FILE
		notify-send -i $FILE 'Screenshot copied to clipboard' -t 2500
	}
	
	active_window () {
		sleep .5
		maim -u -i $(xdotool getactivewindow) $FILE
		notify-send "Screenshot saved $NAME" -i $FILE -t 2500
		paplay $SOUND
		mv $FILE $SCROTDIR/$NAME
	}
	
	case $choice in
		'Fullscreen')
			fullscreen $@
			;;
		'Fullscreen [Clip]')
			fullscreen_clip
			;;
		'Area')
			area
			;;
		'Area [Clip]')
			area_clip
			;;
		'Active window')
			active_window
			;;
	esac
}

applet () {
	screen=''
	area=''
	window=''
	
	options="$screen\n$area\n$window"
	opt="$(echo -e "$options" | $ROFIAPPLET -p '' -dmenu -selected-row 0)"
	execute () {
		case $opt in
			$screen)
				ACTION="maim -u $FILE"
				;;
			$area)
				ACTION="maim -s $FILE"
				;;
			$window)
				ACTION="maim -u -i $(xdotool getactivewindow) $FILE"
				;;
		esac
	
		if [[ $opt = $screen ]] && [[ $location = $disc ]]; then
			countdown $@
		fi

		if [[ $location = $clip ]]; then
			sleep .5
			$ACTION
			xclip -selection clipboard -t image/png < $FILE
			notify-send -i $FILE "Screenshot copied to clipboard"
		elif [[ $location = $disc ]]; then
			sleep .5
			$ACTION
			notification &
			paplay $SOUND
			mv $FILE $SCROTDIR/$NAME
		fi
	}
	
	location () {
		clip="" #
		disc="" #
	
		conf="$clip\n$disc"
	
		if [[ -z $opt ]]; then
			exit 0
		else
			location="$(echo -e "$conf" | $ROFIAPPLET -p '' -dmenu -selected-row 1)"
		fi
	}
	
	location && execute $@
	
	exit 0
}

case $1 in
	-m|--menu)
		menu $@
		;;
	-a|--applet)
		applet $@
		;;
	*)
		menu $@
		;;
esac
