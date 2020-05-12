#!/bin/sh

refreshbar () {
	kill "$(pstree -lp | grep -- -statusbar.sh\([0-9] | sed "s/.*sleep(\([0-9]\+\)).*/\1/")" 2> /dev/null
}

case $1 in
	prev)
	mpc -q prev
	refreshbar
		;;
	next)
	mpc -q next
	refreshbar
		;;
	play)
	mpc -q toggle
	refreshbar
		;;
esac
