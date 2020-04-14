#!/bin/sh

MENU=$(echo -e 'local\nlink\ndownload' | dmenu -p 'link/local: ')

local_storage () {
	DIR="$HOME/movies/"
	CHOICE="$(ls $DIR | dmenu -l 5 -p 'select video ')"
	if [[ "$CHOICE" = *.mkv ]]; then
		mpv "$DIR$CHOICE"
		exit 0
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
	LINK=$( (echo 1 | grep 0) | dmenu -p 'paste a link to a video ')
	if [[ -n $LINK ]]; then
		mpv --ytdl-format="[height=720]" $LINK
	else
		exit 0
	fi

	STATUS=$?

	if [[ $STATUS != 0 ]]; then
		notify-send -u critical -t 2000 'video cannot be opened'
	fi
}

download () {
	LINK=$(echo | grep 0 | dmenu -p 'paste a link to a video ')
	if [[ -z $LINK ]]; then
		exit 0
	fi
	cd $HOME/movies
	youtube-dl -f bestvideo[height=1080]+bestaudio[ext=m4a] --merge-output-format mkv $LINK
	STATUS=$?
	if [[ $STATUS != 0 ]]; then
		notify-send -u critical -t 2000 'video cannot be downloaded'
		exit 0
	else
		notify-send -t 2000 'video downloaded'
	fi
}

case $MENU in
	link)
		by_link
		;;
	local)
		local_storage
		;;
	download)
		download
		;;
	*)
		exit 0
		;;
esac
