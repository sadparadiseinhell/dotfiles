#!/bin/bash

START="/usr/share/sounds/freedesktop/stereo/window-attention.oga"
END="/usr/share/sounds/freedesktop/stereo/alarm-clock-elapsed.oga"
TIME=$(echo -e "5 minutes\n30 minutes\n1 hour\nstop timer" | dmenu -p 'set the time  ')

if [[ -z $TIME ]]; then
	notify-send -u low "try another time" -t 2000
	exit
elif [[ $TIME = "5 minutes" ]]; then
	SEC=300
elif [[ $TIME = "30 minutes" ]]; then
	SEC=1800
elif [[ $TIME = "1 hour" ]]; then
	SEC=3600
elif [[ $TIME = "stop timer" ]]; then
	if [[ $(ps -aux | grep [t]t.sh | wc -l) -ge 1 ]]; then
		notify-send -u low "timer stopped" -t 2000
		killall tt.sh
	fi
else
	case "$TIME" in
		*s) TIME=$(echo $TIME | sed 's/s//')
		SEC=$TIME ;;
		*m) TIME=$(echo $TIME | sed 's/m//')
		SEC=$(echo "$TIME*60" | bc ) ;;
		*h) TIME=$(echo $TIME | sed 's/h//')
		SEC=$(echo "$TIME*3600" | bc ) ;;
		*) SEC=$TIME ;;
	esac
fi

paplay "$START" 2>/dev/null &
notify-send -u normal "timer started" -t 3000
	
for (( i=$SEC; i>0; i--)); do
	secl="$(date -d"0+$i sec" +%H:%M:%S)"
	printf "\r$secl" &
	sleep 1
done

paplay "$END" 2>/dev/null &
notify-send -u critical "timer finished" -t 6000
