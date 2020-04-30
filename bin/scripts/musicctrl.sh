#!/bin/sh

refreshbar () {
	kill "$(pstree -lp | grep -- -statusbar.sh\([0-9] | sed "s/.*sleep(\([0-9]\+\)).*/\1/")" 2> /dev/null
}

case $1 in
	prev)
	mpc prev &> /dev/null
	refreshbar
		;;
	next)
	mpc next &> /dev/null
	refreshbar
		;;
	play)
	mpc toggle &> /dev/null
	refreshbar
		;;
esac
