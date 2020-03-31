#!/bin/bash

MENU=$(echo -e 'link\nlocal' | dmenu -p 'link/local: ')

local_storage () {
	DIR="$HOME/movies/"
	CHOICE="$(ls $DIR | dmenu -l 5 -p 'select video ')"
	if [[ "$CHOICE" = *.mkv ]]; then
		mpv "$DIR$CHOICE"
	elif [[ -d "$DIR$CHOICE" ]]; then
		cd "$DIR$CHOICE"
		mpv *{.mkv,.avi,.mp4}
		if [[ $STATUS != 0 ]]; then
			cd $(ls $DIR$CHOICE)
			mpv *{.mkv,.avi,.mp4}
			exit 0
		fi
	else
		exit 0
	fi

	STATUS=$?

	if [[ $STATUS != 0 ]]; then
		notify-send -u critical -t 2000 'video cannot be opened'
	fi

}

by_link () {
	CHOICE=$( (echo 1 | grep 0) | dmenu -p 'paste a link to a video ')
	if [[ -n $CHOICE ]]; then
		mpv --ytdl-format="[height=720]" $CHOICE
	else
		exit 0
	fi

	STATUS=$?

	if [[ $STATUS != 0 ]]; then
		notify-send -u critical -t 2000 'video cannot be opened'
	fi
}

case $MENU in
	link)
		by_link
		;;
	local)
		local_storage
		;;
	*)
		exit 0
		;;
esac
