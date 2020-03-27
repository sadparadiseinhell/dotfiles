#!/bin/sh

picom --config $HOME/.config/picom.conf &                                  # composite manager
$HOME/scripts/statusbar.sh &                                               # bar
$HOME/scripts/wallpaper.sh &                                               # set wallpaper
setxkbmap -model pc105 -layout us,ru,ua -option grp:ctrl_alt_toggle &      # keyboard layout
dunst -config $HOME/.config/dunst/dunstrc &                                # notification daemon
xautolock -time 10 -detectsleep -locker "$HOME/scripts/lock.sh" \
-notify 10 -notifier "notify-send --urgency normal --expire-time=3500 \
'locking screen in 10 seconds'" -corners +-00 -cornerdelay 10 \
-cornerredelay 10 -cornersize 20 &                                         # automatic screen lock

if [ "$(ps -aux | grep [m]pd | wc -l)" -eq 0 ]; then                       #
	mpd
else                                                                       # MPD
	echo ':('  > /dev/null
fi &                                                                       #

paplay /usr/share/sounds/freedesktop/stereo/service-login.oga &            # startup sound
$HOME/scripts/greeting.sh &                                                # greeting script
$HOME/scripts/todonotify.sh &                                              # To-Do notification
$HOME/scripts/updates.sh &                                                 # update notification script
$HOME/scripts/tinynotify.sh &                                              # MPD notification script