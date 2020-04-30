#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

# - # - #

#$HOME/scripts/dwmautostart.sh &
#while true; do
#   dwm >/dev/null 2>&1
#done

exec openbox-session
