#!/bin/sh

source $HOME/scripts/launcher.sh

START='/usr/share/sounds/freedesktop/stereo/window-attention.oga'
END='/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga'
TIME=$(echo -e '5 minutes\n30 minutes\n1 hour\nStop timer' | $LAUNCHER -i -p 'Timer ')

start () {
	if [[ $TIME = *'m' ]]; then
		t=$(echo "$TIME" | sed 's/m/ minute(s)/')
	elif [[ $TIME = '5 minutes' || $TIME = '30 minutes' || $TIME = '1 hour' ]]; then
		t=$(echo "$TIME")
	elif [[ $TIME = *'s' ]]; then
		t=$(echo "$TIME" | sed 's/s/ second(s)/')
	elif [[ $TIME = *'h' ]]; then
		t=$(echo "$TIME" | sed 's/h/ hour(s)/')
	else
		t=$(echo "$TIME second(s)")
	fi

	paplay "$START" 2>/dev/null &
	notify-send 'timer is set to' "$t" -t 3000 &
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
