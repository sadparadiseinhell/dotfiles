#!/bin/sh

source $HOME/scripts/launcher.sh

OPT="$(printf 'Lock\nLogout\nSuspend\nHibernate\nReboot\nPoweroff' | $LAUNCHER -i -p 'Power menu ')"
execute () {
	case $OPT in
		Poweroff) ACTION="systemctl poweroff";;
		Reboot) ACTION="systemctl reboot";;
		Hibernate) ACTION="systemctl hibernate";;
		Suspend) ACTION="systemctl suspend";;
		Lock) ACTION="$HOME/scripts/lock.sh" ;;
		Logout) ACTION="/usr/bin/killall xinit" ;;
	esac

	if [[ $OPT = 'Poweroff' ]] && [[ $CONFIRM = 'Yes' ]]; then
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
