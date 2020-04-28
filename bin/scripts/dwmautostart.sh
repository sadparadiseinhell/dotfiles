#!/bin/sh

picom --config $HOME/.config/picom.conf &                                  # composite manager
#picom --config $HOME/.config/picom.conf \
#--blur-method 'dual_kawase' --blur-strength 8 \
#--experimental-backends &
$HOME/scripts/statusbar.sh &                                               # bar
$HOME/scripts/theme.sh -R &                                                # set theme
setxkbmap -model pc105 -layout us,ru,ua -option grp:ctrl_alt_toggle &      # keyboard layout
dunst -config $HOME/.config/dunst/dunstrc &                                # notification daemon
xautolock -time 10 -detectsleep -locker "$HOME/scripts/lock.sh" \
-notify 10 -notifier "notify-send --urgency normal --expire-time=3500 \
'locking screen in 10 seconds'" -corners +-00 -cornerdelay 10 \
-cornerredelay 10 -cornersize 20 &                                         # automatic screen lock

if [ "$(ps -aux | grep '[m]pd' | wc -l)" -eq 0 ]; then                     #
	mpd                                                                    # MPD
fi &                                                                       #

paplay /usr/share/sounds/freedesktop/stereo/service-login.oga &            # startup sound
sleep 4; $HOME/scripts/greeting.sh &                                       # greeting
sleep 8; $HOME/scripts/todonotify.sh &                                     # To-Do notification
$HOME/scripts/updates.sh &                                                 # update notification
$HOME/scripts/tinympdnotify.sh &                                           # MPD notification
