#!/bin/sh

ARTIST=$(mpc list artist | dmenu -i -p 'artist ')
NUM=$(mpc list album artist "$ARTIST" | wc -l)
if [[ -z $ARTIST ]]; then
	exit 0
else
	if [[ $NUM -eq 1 ]]; then
		mpc clear > /dev/null
		mpc find artist "$ARTIST" | mpc add
		$HOME/scripts/mpdctrl.sh play
		exit 0
	else
		ALBUM=$(mpc list album artist "$ARTIST" | dmenu -p 'album ')
		if [[ -z $ALBUM ]]; then
			exit 0
		fi
		mpc clear > /dev/null
		mpc find artist "$ARTIST" album "$ALBUM" | mpc add
		$HOME/scripts/mpdctrl.sh play
	fi
fi
