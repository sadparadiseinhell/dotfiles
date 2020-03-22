#!/bin/sh

source $HOME/.cache/wal/colors.sh

dt(){
	time="$(date '+%H:%M')"
	date="$(date '+%a, %b %d')"
	echo -e " ^c$color2^^d^ $date  ^c$color4^^d^ $time  "
}

upd(){
	upd="$(checkupdates | wc -l)"
	echo -e " ^c$color1^^d^ $upd "
}

alsa () {
	vol="$(amixer get Master | grep -o "[0-9]*%" | tr -d '%')"

	if [ "$vol" -eq 0 ]; then
		echo "  ^c$color6^ muted^d^ "
	elif [ "$vol" -eq 0 ]; then
        echo "  ^c$color7^^d^ $vol% "
    elif [ "$vol" -le 50 ]; then
        echo "  ^c$color4^^d^ $vol% "
    elif [ "$vol" -le 100 ]; then
        echo "  ^c$color1^^d^ $vol% "
    fi
}

pulse () {
    vol="$(pamixer --get-volume-human | tr -d '%')"

    if [ "$vol" = "muted" ]; then
        echo "  ^c$color6^^d^ $vol "
    elif [ "$vol" -eq 0 ]; then
        echo "  ^c$color7^^d^ $vol% "
    elif [ "$vol" -le 50 ]; then
        echo "  ^c$color4^^d^ $vol% "
    elif [ "$vol" -le 100 ]; then
        echo "  ^c$color1^^d^ $vol% "
    fi
}

mpd () {
	mpd="$(mpc current --format "%artist% - %title%" 2> /dev/null)"
	if [[ -n "$mpd" ]]; then
		echo "  ^c$color1^^d^  $(echo $mpd) " 
	fi
}

cnnctn () {
	ping -c 1 8.8.8.8 &> /dev/null
	if [ $? != 0 ]; then
		echo " ^c$color1^^d^ Down "
	else
		echo " ^c$color2^^d^ Up "
	fi
}

kblayout () {
	echo -e " ^c$color4^^d^ $(skb -1) "
}

while true; do
	xsetroot -name "$(pulse) $(upd) $(dt)"
	sleep 1m
done &