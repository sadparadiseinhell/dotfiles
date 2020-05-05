#!/bin/sh

source $HOME/scripts/launcher.sh

MENU=$(printf 'Start\nStop' | $LAUNCHER -i -p 'Screencast ')
NAME="$(date +%G_%m_%d_%T)_screencast.mp4"

case $MENU in
	Start)
	echo 'start'
	notify-send 'Screencast recording started' -t 1000
	sleep 1
	ffmpeg -f x11grab  -y -rtbufsize 100M -s 1680x1050 -framerate 30 -probesize 10M -draw_mouse 0 -i :0.0 -c:v libx264 -r 30 -preset ultrafast -tune zerolatency -crf 25 -pix_fmt yuv420p $HOME/screenshots/$NAME
		;;
	Stop)
	echo 'stop'
	killall ffmpeg
	notify-send 'Screencast saved!' -t 2000
		;;
	*)
	exit 0
		;;
esac


#TMPFILE='/tmp/rec_reg.avi'

#rm $TMPFILE &> /dev/null

#ffmpeg() {
#    command ffmpeg -hide_banner -loglevel error -nostdin "$@"
#}

#video_to_gif() {
#    ffmpeg -i "$1" -vf palettegen -f image2 -c:v png - |
#    ffmpeg -i "$1" -i - -filter_complex paletteuse "$2"
#}

#scrot_from_video () {
#    SCROT='/tmp/scrot_from_video.png'
#    ffmpeg -ss 00:00:01 -i $TMPFILE -y -f image2 -vframes 1 $SCROT
#}

#record_region_file () {
#    OPT=$(echo -e 'start\nstop' | $LAUNCHER -p 'Record screen [mp4] ')
#    case $OPT in
#        start)
#            SCROT='/tmp/scrot_from_video.png'
#
#            notify-send "Select a region to record" -t 2000
#
#            info=( $(xrectsel "%w %h %x %y") )
#            w=${info[0]}
#            h=${info[1]}
#            x=${info[2]}
#            y=${info[3]}
#
#            if [[ "$w" -lt 5 && "$h" -lt 5 ]]; then
#                notify-send "Select a region!" -t 2000
#                exit
#            fi
#
#            countdown
#            ffmpeg -f x11grab \
#            -an \
#            -s "${w}x${h}" \
#            -r 20 \
#            -v:b 23000 \
#            -i ":0.0+$x,$y" \
#            -g 1 \
#            -q:v 0.1 \
#            -vcodec libxvid $TMPFILE
#            ;;
#        stop)
#            killall ffmpeg
#            scrot_from_video
#            mv $TMPFILE "$SCROTDIR$(date +%G_%m_%d_%T).mp4"
#            notify-send -i $SCROT "Recording saved to $SCROTDIR"
#            ;;
#    esac
#}

#record_full_file () {
#    OPT=$(echo -e 'start\nstop' | $LAUNCHER -p 'Record screen [mp4] ')
#    case $OPT in
#        start)
#            countdown
#            ffmpeg -f x11grab -an -s 1680x1050 -r 15 -v:b 23000 -i :0.0 -g 1 -q:v 0.1 -vcodec libxvid $TMPFILE
#            ;;
#        stop)
#            killall ffmpeg
#            scrot_from_video
#            mv $TMPFILE "$SCROTDIR$(date +%G_%m_%d_%T).mp4"
#            notify-send -i $SCROT "Recording saved to $SCROTDIR" &
#            ;;
#    esac
#}

#record_region_gif () {
#    OPT=$(echo -e 'start\nstop' | $LAUNCHER -p 'Record region [GIF] ')
#    case $OPT in
#        start)
#            notify-send "Select a region to record" -t 2500
#
#            info=( $(xrectsel "%w %h %x %y") )
#            w=${info[0]}
#            h=${info[1]}
#            x=${info[2]}
#            y=${info[3]}
#
#            countdown
#            ffmpeg -f x11grab \
#            -an -s "${w}x${h}" \
#            -r 15 \
#            -v:b 23000 \
#            -i ":0.0+$x,$y" \
#            -g 1 \
#            -q:v 0.1 \
#            -vcodec libxvid $TMPFILE
#            ;;
#        stop)
#            killall ffmpeg
#            scrot_from_video
#            notify-send "Converting to gif... (this can take a while)" -t 2000
#            video_to_gif $TMPFILE "$SCROTDIR$(date +%G_%m_%d_%T).gif"
#            rm $TMPFILE
#            notify-send -i $SCROT "Recording saved to $SCROTDIR"
#            ;;
#    esac
#}