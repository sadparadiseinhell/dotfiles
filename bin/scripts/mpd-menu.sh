#!/bin/sh

source $HOME/scripts/launcher.sh

applet () {
	rofi_command="rofi -theme mpd.rasi"

	# Gets the current status of mpd (for us to parse it later on)
	status="$(mpc status)"
	# Defines the Play / Pause option content
	if [[ $status == *"[playing]"* ]]; then
	    play_pause=""
	else
	    play_pause=""
	fi
	active=""
	urgent=""
	
	# Display if repeat mode is on / off
	tog_repeat=""
	if [[ $status == *"repeat: on"* ]]; then
	    active="-a 3"
	elif [[ $status == *"repeat: off"* ]]; then
	    urgent="-u 3"
	else
	    tog_repeat=" Parsing error"
	fi
	
	# Display if random mode is on / off
	tog_random=""
	if [[ $status == *"random: on"* ]]; then
	    [ -n "$active" ] && active+=",4" || active="-a 4"
	elif [[ $status == *"random: off"* ]]; then
	    [ -n "$urgent" ] && urgent+=",4" || urgent="-u 4"
	else
	    tog_random=" Parsing error"
	fi
	stop=""
	next=""
	previous=""
	
	# Variable passed to rofi
	options="$previous\n$play_pause\n$next\n$tog_repeat\n$tog_random"
	
	# Get the current playing song
	NUM=$(mpc -f %title% current | wc -c)
	if [[ $NUM -ge '25' ]]; then
	    current=$(echo $(mpc -f %title% current | cut -c -25)...)
	elif [[ -z "$(mpc -f %title% current)" ]]; then
	    current="-"
	else
	    current=$(mpc -f %title% current)
	fi
	
	# Spawn the mpd menu with the "Play / Pause" entry selected by default
	chosen="$(echo -e "$options" | $rofi_command -p "$current" -dmenu $active $urgent -selected-row 1)"
	case $chosen in
	    $previous)
	        mpc -q prev
	        ;;
	    $play_pause)
	        $HOME/scripts/musicctrl.sh play
	        ;;
	    #$stop)
	    #    mpc -q stop
	    #    ;;
	    $next)
	        mpc -q next
	        ;;
	    $tog_repeat)
	        mpc -q repeat
	        if [[ $status == *"repeat: off"* ]]; then
	            notify-send 'Repeat mode is on' -t 2000
	        else
	            notify-send 'Repeat mode is off' -t 2000
	        fi
	        ;;
	    $tog_random)
	        mpc -q random
	        if [[ $status == *"random: off"* ]]; then
	            notify-send 'Random mode is on' -t 2000
	        else
	            notify-send 'Random mode is off' -t 2000
	        fi
	        ;;
	esac
}

menu () {
artist() {
	lines(){ mpc list artist | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list artist | sort -f | $LAUNCHER -i -p "Artists " -l $lines
}

a_album() {
	artist="$1"
	lines(){ mpc list album artist "$artist" | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list album artist "$artist" | sort -f | $LAUNCHER -i -p "Albums " -l $lines
}

album() {
	lines(){ mpc list album | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list album | sort -f | $LAUNCHER -i -p "Album " -l $lines
}

song() {
	lines(){ mpc list title | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list title | sort -f | $LAUNCHER -i -p "Song " -l $lines
}

MODE=$(printf "Control\nLibrary\nAlbum\nSong" | $LAUNCHER -l 4 -i -p "Choose mode ")

case "$MODE" in
	Control)
		applet
		;;
	Library)
		artist=$(artist)
		[ ! "$artist" ] && exit
		album=$(a_album "$artist")
		[ ! "$album" ] && exit
		mpc clear > /dev/null
		mpc find artist "$artist" album "$album" | mpc add
		$HOME/scripts/musicctrl.sh play
		;;
	Song) 
		song=$(song)		
		[ ! "$song" ] && exit
		mpc clear > /dev/null
		mpc search title "$song" | mpc add
		$HOME/scripts/musicctrl.sh play
		;;
	Album)
		album=$(album)
		[ ! "$album" ] && exit
		mpc clear > /dev/null
		mpc find album "$album" | mpc add
		$HOME/scripts/musicctrl.sh play
		;;
esac
}

case $1 in
	-m)
		menu
		;;
	-a)
		applet
		;;
	*)
		menu
		;;
esac