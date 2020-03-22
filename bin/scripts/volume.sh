#!/bin/sh

refreshbar () {
	kill "$(pstree -lp | grep -- -statusbar.sh\([0-9] | sed "s/.*sleep(\([0-9]\+\)).*/\1/")"
}

case $1 in
	up)
	pamixer -u &> /dev/null
	pamixer -i 5 &> /dev/null
	refreshbar
	;;
	down)
	pamixer -u &> /dev/null
	pamixer -d 5 &> /dev/null
	refreshbar
	;;
	mute)
	pamixer -t &> /dev/null
	refreshbar
	;;
esac
