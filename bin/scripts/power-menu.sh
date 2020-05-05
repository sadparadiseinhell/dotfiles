#!/bin/sh

source $HOME/scripts/launcher.sh

OPT="$(printf 'Lock\nLogout\nSuspend\nHibernate\nReboot\nPoweroff' | $LAUNCHER -i -p 'Power menu ')"
execute () {
	case $OPT in
		H*|R*|S*|P*) ACTION="systemctl $OPT" ;;
		Lock) ACTION="$HOME/scripts/lock.sh" ;;
		Logout) ACTION="/usr/bin/killall xinit" ;;
	esac

	if [[ $OPT = 'poweroff' ]] && [[ $CONFIRM = 'yes' ]]; then
		paplay '/usr/share/sounds/freedesktop/stereo/service-logout.oga'
	fi

	if [[ $CONFIRM = 'Yes' ]]; then
		$ACTION
	elif [[ $CONFIRM = 'No' ]]; then
		echo ':('
	fi
}

confirm () {
	if [[ -z $OPT ]]; then
		exit 0
	else
		CONFIRM=$(printf 'No\nYes' | $LAUNCHER -i -p "$OPT ")
	fi
}

confirm && execute

exit 0
