#!/bin/sh

source $HOME/scripts/launcher.sh

MENU=$(echo -e 'start\nstop' | $LAUNCHER -p 'screencast ')
NAME="$(date +%G_%m_%d_%T)_screencast.mp4"

case $MENU in
	start)
	echo 'start'
	notify-send 'screencast recording started' -t 1000
	sleep 1
	ffmpeg -f x11grab  -y -rtbufsize 100M -s 1680x1050 -framerate 30 -probesize 10M -draw_mouse 0 -i :0.0 -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p $HOME/screenshots/$NAME
		;;
	stop)
	echo 'stop'
	killall ffmpeg
	notify-send 'screencast saved!' -t 2000
		;;
	*)
	exit 0
		;;
esac