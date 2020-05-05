#!/bin/sh

source $HOME/scripts/launcher.sh

DOWNLOADS_DIR="$HOME/movies/downloads/"
MENU=$(echo -e 'Local\nLink\nTwitch\nSearch (YouTube)\nDownload' | $LAUNCHER -i -p 'Link/Local: ')

local_storage () {
	DIR="$HOME/movies/"
	CHOICE="$(ls $DIR | $LAUNCHER -l 5 -p 'Select video ')"
	if [[ -n $CHOICE ]] && [[ "$CHOICE" = *.mkv ]]; then
		if [[ -z $CHOICE ]]; then
			exit 0
		fi
		mpv "$DIR$CHOICE"
		exit 0
	elif [[ -n $CHOICE ]] && [[ -d "$DIR$CHOICE" ]]; then
		if [[ -z $CHOICE ]]; then
			exit 0
		fi
		cd "$DIR$CHOICE"
		NUM=$(ls "$DIR$CHOICE" | grep "\.mkv\|\.avi\|\.mp4" | wc -l)
		if [[ $NUM -gt 1 ]]; then
			cd "$DIR$CHOICE"
			CHOICE="$(ls $PWD | $LAUNCHER -l 5 -p 'Select video ')"
			if [[ -z $CHOICE ]]; then
				exit 0
			fi
			DIR="$PWD/"
			if [[ -n $CHOICE ]]; then
				mpv "$DIR$CHOICE"
				exit 0
			fi
		fi
		mpv *{.mkv,.avi,.mp4}
		if [[ $? != 0 ]]; then
			cd $(ls $DIR$CHOICE)
			mpv *{.mkv,.avi,.mp4}
			exit 0
		fi
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 "Video can't be opened"
	fi
}

by_link () {
	LINK=$( (echo | grep 0) | $LAUNCHER -i -p 'Paste a link to a video ')
	if [[ -n $LINK ]]; then
		mpv --ytdl-format="[height=720]" $LINK
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 "Video can't be opened"
	fi
}

download () {
	if [[ ! -d $DOWNLOADS_DIR ]]; then
		mkdir $DOWNLOADS_DIR
	fi

	LINK=$(echo | grep 0 | $LAUNCHER -i -p 'Paste a link to a video ')
	if [[ -z $LINK ]]; then
		exit 0
	fi

	QUALITY=$(echo -e '480\n720\n1080' | $LAUNCHER -i -p 'Quality ')
	if [[ -z $QUALITY ]]; then
		QUALITY='1080'
	fi

	if [[ $QUALITY != '1080' ]] && [[ $QUALITY != '720' ]] && [[ $QUALITY != '480' ]]; then
		exit 0
	fi

	cd $DOWNLOADS_DIR
	youtube-dl -f bestvideo[height=$QUALITY]+bestaudio[ext=m4a] --merge-output-format mkv $LINK

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 "Video can't be downloaded"
		exit 0
	else
		notify-send -t 2000 'Video downloaded'
	fi
}

yt_search () {
	INPUT=$(echo | grep 0 | $LAUNCHER -i -p 'Search ')
	if [[ -n $INPUT ]]; then
		mpv --ytdl-format="bestvideo[height<=1080]+bestaudio" ytdl://ytsearch:"$INPUT"
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 "Video can't be opened"
	fi
}

twitch () {
	LINK=$(echo | grep 0 | $LAUNCHER -i -p 'Paste a link ')
	if [[ -n $LINK ]]; then
		mpv --ytdl-format="720p+bestaudio" $LINK
	else
		exit 0
	fi

	if [[ $? != 0 ]]; then
		notify-send -u critical -t 3000 "Video can't be opened"
	fi
}

case $MENU in
	Link)
		by_link
		;;
	Local)
		local_storage
		;;
	Download)
		download
		;;
	Search*)
		yt_search
		;;
	Twitch)
		twitch
		;;
	*)
		exit 0
		;;
esac
