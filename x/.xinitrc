#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# - # - #

DEFAULTSESSION='openbox-session'

case "$1" in
	openbox)
		exec openbox-session
		;;
	*)
		exec $DEFAULTSESSION
		;;
esac
