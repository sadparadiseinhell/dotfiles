#!/bin/sh

source $HOME/scripts/launcher.sh

OPT="$(echo -e 'lock\nlogout\nsuspend\nhibernate\nreboot\npoweroff' | $LAUNCHER -p 'power menu ')"
execute () {
	case $OPT in
		h*|r*|s*|p*) ACTION="systemctl $OPT" ;;
		lock) ACTION="$HOME/scripts/lock.sh" ;;
		logout) ACTION="/usr/bin/killall xinit" ;;
	esac

	if [[ $OPT = 'poweroff' ]] && [[ $CONFIRM = 'yes' ]]; then
		paplay '/usr/share/sounds/freedesktop/stereo/service-logout.oga'
	fi

	if [[ $CONFIRM = 'yes' ]]; then
		$ACTION
	elif [[ $CONFIRM = 'no' ]]; then
		echo ':('
	fi
}

confirm () {
	if [[ -z $OPT ]]; then
		exit 0
	else
		CONFIRM=$(echo -e 'no\nyes' | $LAUNCHER -p "$OPT ")
	fi
}

confirm && execute

exit 0
