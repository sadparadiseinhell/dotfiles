#!/bin/sh

source $HOME/scripts/launcher.sh

START='/usr/share/sounds/freedesktop/stereo/window-attention.oga'
END='/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga'
TIME=$(echo -e '5 minutes\n30 minutes\n1 hour\nStop timer' | $LAUNCHER -i -p 'Timer ')

start () {
	paplay "$START" 2>/dev/null &
	notify-send 'timer is set to' "$TIME" -t 3000 &
}

if [[ -n $TIME ]]; then
	case $TIME in
		'5 minutes')
			start
			sleep 5m
			;;
		'30 minutes')
			start
			sleep 30m
			;;
		'1 hour')
			start
			sleep 1h
			;;
		Stop*)
			notify-send 'Timer stopped' -t 2000
			killall test.sh
			;;
		*s|*m|*h)
			start
			sleep $TIME
			;;
		*)
			notify-send -u critical 'Error' 'Pls try again' -t 5000
			exit 1
			;;
	esac
	paplay "$END" 2>/dev/null &
	notify-send -u critical 'Timer finished' -t 6000
else
	exit 0
fi
