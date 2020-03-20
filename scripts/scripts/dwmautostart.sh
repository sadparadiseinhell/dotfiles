#!/bin/sh

# - - - Bar - - - #

dte(){
	time="$(date '+%H:%M')"
	date="$(date '+%a, %d, %b')"
	echo -e " ^c#cc99ff^^d^ $date  ^c#99c2ff^^d^ $time "
}

upd(){
	upd="$(checkupdates | wc -l)"
	echo -e " ^c#ff9999^^d^ $upd "
}

weather(){
	weather="$(curl -s wttr.in/city_name?format="+%t")"
	echo -e "  $weather "
}

alsa () {
	vol="$(amixer get Master | grep -o "[0-9]*%" | tr -d '%')"

	if [ "$vol" -eq 0 ]; then
		echo "  ^c#ff695c^muted^d^ "
	elif [ "$vol" -eq 0 ]; then
        echo "  ^c#ffb380^^d^ $vol% "
    elif [ "$vol" -le 50 ]; then
        echo "  ^c#80d182^^d^ $vol% "
    elif [ "$vol" -le 100 ]; then
        echo "  ^c#ff9999^^d^ $vol% "
    fi
}

pulse () {
    vol="$(pamixer --get-volume-human | tr -d '%')"

    if [ "$vol" = "muted" ]; then
        echo "  ^c#ff695c^^d^ $vol "
    elif [ "$vol" -eq 0 ]; then
        echo "  ^c#ffb380^^d^ $vol% "
    elif [ "$vol" -le 50 ]; then
        echo "  ^c#80d182^^d^ $vol% "
    elif [ "$vol" -le 100 ]; then
        echo "  ^c#ff9999^^d^ $vol% "
    fi
}

mpd () {
	mpd="$(mpc current --format "%artist% - %title%" 2> /dev/null)"
	if [[ -n "$mpd" ]]; then
		echo "  ^c#e64d4d^^d^  $(echo $mpd) " 
	fi
}

cnnctn () {
	ping -c 1 8.8.8.8 &> /dev/null
	if [ $? != 0 ]; then
		echo " ^c#ff9999^^d^ Down "
	else
		echo " ^c#74c474^^d^ Up "
	fi
}

kblayout () {
	echo -e " ^c#ffccff^^d^ $(skb -1) "
}

while true; do
	xsetroot -name "$(pulse) $(upd) $(dte)"
	sleep 1
done &

# - - - Autostart - - - #

picom --config $HOME/.config/picom.conf &                                 # composite manager
setxkbmap -model pc105 -layout us,ru,ua -option grp:ctrl_alt_toggle &     # keyboard layout
dunst -config $HOME/.cache/wal/dwm-dunstrc &                              # notification daemon
xautolock -time 10 -detectsleep -locker "$HOME/scripts/lock.sh" \
-notify 10 -notifier "notify-send --urgency normal --expire-time=3500 \
'locking screen in 10 seconds'" -corners +-00 -cornerdelay 10 \
-cornerredelay 10 -cornersize 20 &                                        # automatic screen lock
clipmenud &                                                               # clipboard manager

if [ "$(ps -aux | grep [m]pd | wc -l)" -eq 0 ]; then                      #
	mpd                                                                   #
else                                                                      # MPD
	echo ":(" &> /dev/null                                                #
fi                                                                        #

sleep 1                                                                   # zZzZz
paplay /usr/share/sounds/freedesktop/stereo/service-login.oga &           # startup sound
sleep 2                                                                   # zZzZz
notify-send "$($HOME/scripts/greeting.sh)" &                              # greeting script
$HOME/scripts/updates.sh &                                                # update notification script
$HOME/scripts/tinynotify-2.0.sh &                                         # MPD notification script
$HOME/scripts/todonotify.sh                                               # To-Do notification
