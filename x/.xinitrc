#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# - # - #

DEFAULTSESSION='openbox-session'

dynamic_wm () {
	$HOME/scripts/dwmautostart.sh &
	while true; do
		dwm >/dev/null 2>&1
	done
}

case "$1" in
	openbox)
		exec openbox-session
		;;
	dwm)
		dynamic_wm
		;;
	*)
		exec $DEFAULTSESSION
		;;
esac
