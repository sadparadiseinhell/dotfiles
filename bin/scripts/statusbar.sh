#!/bin/sh

# Colors
source $HOME/.colors/dracula.sh

# Date
dte (){
	DATE="$(date '+%a, %b %d')"
	echo -e " ^c$color3^^d^ $DATE "
	#echo -e "  $date "
}

# Time
tme () {
	TIME="$(date '+%H:%M')"
	echo -e " ^c$color4^^d^ $TIME  "
	#echo -e "  $time  "
}

# Updates
upd (){
	UPD="$(checkupdates | wc -l)"
	#echo -e "  $upd "
	if [[ "$UPD" -eq 0 ]]; then
		echo -e " ^c$color8^^d^ $UPD "
	elif [[ "$UPD" -le 5 ]]; then
		echo -e " ^c$color3^^d^ $UPD "
	else
		echo -e " ^c$color1^^d^ $UPD "
	fi
}

# Volume (ALSA)
alsa () {
	VOL="$(amixer get Master | grep -o "[0-9]*%" | tr -d '%')"
	if [ "$VOL" -eq 0 ]; then
		echo "  ^c$color1^muted^d^ "
	elif [ "$VOL" -eq 0 ]; then
        echo "  ^c$color7^^d^ $VOL% "
    elif [ "$VOL" -le 50 ]; then
        echo "  ^c$color2^^d^ $VOL% "
    elif [ "$VOL" -le 100 ]; then
        echo "  ^c$color1^^d^ $VOL% "
    fi
}

# Volume (PulseAudio)
pulse () {
	VOL="$(pamixer --get-volume-human | tr -d '%')"
	if [ "$VOL" = "muted" ]; then
		echo "  ^c$color1^ $VOL^d^ "
		#echo "  $VOL "
	elif [ "$VOL" -eq 0 ]; then
		echo "  ^c$color7^^d^ $VOL% "
		#echo "   $VOL% "
	elif [ "$VOL" -le 50 ]; then
		echo "  ^c$color2^^d^ $VOL% "
		#echo "   $VOL% "
	elif [ "$VOL" -le 100 ]; then
		echo "  ^c$color1^^d^ $VOL% "
		#echo "   $VOL% "
	fi
}

# Current song
mpd () {
	MPD="$(mpc current --format "%artist% - %title%" 2> /dev/null)"
	if [[ -n "$MPD" ]]; then
		echo "  ^c$color1^^d^  $(echo $MPD) "
		#echo "    $(echo $MPD) " 
	fi
}

# Connection status
cnnctn () {
	ping -c 1 8.8.8.8 &> /dev/null
	if [ $? != 0 ]; then
		echo " ^c$color1^^d^ Down "
		#echo "  Down "
	else
		echo " ^c$color2^^d^ Up "
		#echo "  Up "
	fi
}

# Weather
weather () {
	LOCATION='YOUR_CITY'
	WEATHER="$(curl -s wttr.in/$LOCATION?format=%t)"
	echo " ^c$color6^^d^ $WEATHER "
}

while true; do
	xsetroot -name "$(pulse) $(upd) $(weather) $(dte) $(tme)"
	sleep 60
done &
