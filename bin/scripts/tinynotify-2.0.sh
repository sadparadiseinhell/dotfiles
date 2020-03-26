#!/bin/bash

MUSIC_DIR=$HOME/music/
COVER=/tmp/cover.png
SIZE=150x150

extract_cover() {

    ffmpeg -i "$MUSIC_DIR$(mpc current -f %file%)" $COVER -y &> /dev/null

	STATUS=$?

	if [ $STATUS -eq 0 ];then
        if [ ! $SILENT ];then 
            echo "extracted album art"
        fi
	else
        DIR="$MUSIC_DIR$(dirname "$(mpc current -f %file%)")"
        if [ ! $SILENT ];then
            echo "inspecting $DIR"
        fi

        for CANDIDATE in "$DIR/"[Cc]over""{.png,.jpg}; do
            if [ -f "$CANDIDATE" ]; then
                STATUS=0
                convert "$CANDIDATE" $COVER &> /dev/null
                if [ ! $SILENT ];then
                    echo "found cover.png"
                fi
            fi
        done
    fi

	if [ $STATUS -ne 0 ];then
        if [ ! $SILENT ];then
            echo "error: file does not have an album art"
        fi
	fi

}

while true; do
    mpc current --wait &>/dev/null
    while true; do
        extract_cover
        dunstify -r 3595 -a tinynotify -i $COVER \
        'Now Playing:' "$(mpc current -f "[%artist%\n%title%]" 2> /dev/null)"
        rm /tmp/cover.png

        while true; do
            mpc idle player &>/dev/null && (mpc status | grep "\[playing\]" &>/dev/null) && break
        done
        
    done
done
