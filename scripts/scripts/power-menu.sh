#!/bin/bash

opt="$(echo -e "lock\nlogout\nsuspend\nhibernate\nreboot\npoweroff" | dmenu -p "power menu  ")"
execute () {
	case $opt in
		h*|p*|r*|s*) ACTION="systemctl $opt" ;;
		lock) ACTION="$HOME/scripts/lock.sh" ;;
		logout) ACTION="/usr/bin/killall xinit" ;;
	esac

	if [[ $CONFIRM = "yes" ]]; then
		$ACTION
	elif [[ $CONFIRM = "no" ]]; then
		echo ':('
	fi
}

confirm () {
	CONFIRM=$(echo -e "no\nyes" | dmenu -p "$opt  ")
}

confirm && execute

exit 0