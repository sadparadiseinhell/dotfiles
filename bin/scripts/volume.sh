#!/bin/sh

# Enable to play sound
PLAYSOUND=true

# Sound to play
SOUND=/usr/share/sounds/freedesktop/stereo/audio-volume-change.oga

# At which level the volume is considered too high
WARNINGLEVEL=60

# For how much milliseconds the notification will stay visible
TIMEOUT=1500

# Unique dunst notification id
ID=2593


refreshbar () {
	kill "$(pstree -lp | grep -- -statusbar.sh\([0-9] | sed "s/.*sleep(\([0-9]\+\)).*/\1/")"
}

getVolume () {
    pamixer --get-volume
}

buildBar () {
	$HOME/dotfiles/bin/scripts/drawbar.sh $1 $2 $3
}

sendNotification () {
	VOLUME=`getVolume`
	BODY="`buildBar 5 $VOLUME false` $VOLUME%"
	
	if [ $VOLUME -ge $WARNINGLEVEL ]; then
		URGENCY=critical
	else
		URGENCY=normal
	fi
	
	if [ $PLAYSOUND = true ]; then
		paplay $SOUND &
	fi
	
	dunstify -t "$TIMEOUT" -r "$ID" -u "$URGENCY" "$BODY"
}

case $1 in
	up)
		pamixer -u &> /dev/null
		pamixer -i 5 &> /dev/null
		refreshbar
		sendNotification
		;;
	down)
		pamixer -u &> /dev/null
		pamixer -d 5 &> /dev/null
		refreshbar
		sendNotification
		;;
	mute)
		pamixer -t &> /dev/null
		refreshbar
		if [[ $(pamixer --get-volume-human) = 'muted' ]]; then
			BODY="`buildBar 5 100 true` Muted"
			dunstify -t "$TIMEOUT" -r "$ID" -u "$URGENCY" "$BODY"
		else
			sendNotification
		fi
		;;
esac
