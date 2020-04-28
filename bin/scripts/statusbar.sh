#!/bin/sh

# Date
dte (){
	DATE="$(date '+%a, %b %d')"
	echo -e "  $DATE "
}

# Time
tme () {
	TIME="$(date '+%H:%M')"
	echo -e "  $TIME "
}

# Volume (ALSA)
alsa () {
	VOL="$(amixer get Master | grep -o "[0-9]*%" | tr -d '%')"
	if [ "$VOL" -eq 0 ]; then
		echo " muted "
	elif [ "$VOL" -eq 0 ]; then
        echo "  $VOL% "
    elif [ "$VOL" -le 50 ]; then
        echo "  $VOL% "
    elif [ "$VOL" -le 100 ]; then
        echo "  $VOL% "
    fi
}

# Volume (PulseAudio)
pulse () {
	VOL="$(pamixer --get-volume-human | tr -d '%')"
	if [ "$VOL" = "muted" ]; then
		echo " $VOL "
	elif [ "$VOL" -eq 0 ]; then
		echo "  $VOL% "
	elif [ "$VOL" -le 50 ]; then
		echo "  $VOL% "
	elif [ "$VOL" -le 100 ]; then
		echo "  $VOL% "
	fi
}

# Current song
mpd () {
	MPD="$(mpc current --format "%artist% - %title%" 2> /dev/null)"
	if [[ -n "$MPD" ]]; then
		echo "  $MPD "
	fi
}

# Playing indicator
mpd_indicator () {
	MPDSTATUS=$(mpc status 2> /dev/null | head -n 2 | tail -n 1 | awk '{print $1}')
	if [[ $MPDSTATUS = '[playing]' ]]; then
		echo '   '
	fi
}

# Connection status
cnnctn () {
	ping -c 1 8.8.8.8 &> /dev/null
	if [ $? != 0 ]; then
		echo '  Down '
	else
		echo '  Up '
	fi
}

# Weather
weather () {
	LOCATION='YOUR CITY'
	WEATHER="$(curl -s "wttr.in/$LOCATION?format=%C+%t")"
	echo "  $WEATHER "
}

while true; do
	xsetroot -name " $(pulse) $(dte) $(tme) $(mpd_indicator)"
	sleep 60
done #&
