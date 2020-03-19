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
	if [[ -z $opt ]]; then
		exit 0
	else
		CONFIRM=$(echo -e "no\nyes" | dmenu -p "$opt  ")
	fi
}

confirm && execute

exit 0