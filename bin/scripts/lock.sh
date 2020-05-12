#!/bin/sh

WALLPAPER=$2
CACHEPATH=$HOME/.cache/lockscreen

WIDTH=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $1}')
HEIGHT=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $2}')

TIME_COLOR=ffffff99
DATE_COLOR=ffffff73
FG_COLOR=ffffff80
WRONG_COLOR=ff808099
HIGHLIGHT_COLOR=0808084D
VERIF_COLOR=$FG_COLOR

if [[ $DISPLAY && ! $WM ]]; then
	ID="$(xprop -root -notype _NET_SUPPORTING_WM_CHECK)"
	WM="$(xprop -id ${ID##* } -notype -len 100 -f _NET_WM_NAME 8t)"
	WM=${WM/*WM_NAME = } WM=${WM/\"} WM=${WM/\"*} WM=${WM,,}
fi

cropbg () {
	convert "$WALLPAPER" -resize ${WIDTH}x${HEIGHT}^ -gravity center -crop ${WIDTH}x${HEIGHT}+0+0 +repage \( \
        -size 120x140 xc:none \
        \) -gravity south -compose over -composite $CACHEPATH/resize.png
}

blurbg () {
	convert "$CACHEPATH/resize.png" \
		-filter Gaussian \
		-blur 0x8 \
		-fill black -colorize 15% \
		"$CACHEPATH/resize-blur.png"
}

genbg () {
	echo "Caching image..."
	if [[ ! -d $CACHEPATH ]]; then
		mkdir $CACHEPATH
	fi
	cropbg
	blurbg
	echo "Finished caching image"
}

appearance () {
	i3lock -n --force-clock -i $CACHEPATH/resize-blur.png \
    --indpos="70:h-r*2" --timepos="w/2:h/2" --datepos="w/2:h/2+40" --wrongpos="w/2:h-40" --greeterpos="w/2:h-40"\
    --insidevercolor=$FG_COLOR --insidewrongcolor=$WRONG_COLOR --insidecolor=fefefe00 \
    --ringvercolor=$VERIF_COLOR --ringwrongcolor=$WRONG_COLOR --ringcolor=$FG_COLOR \
    --keyhlcolor=$HIGHLIGHT_COLOR --bshlcolor=$HIGHLIGHT_COLOR --separatorcolor=00000000 \
    --datecolor=$DATE_COLOR --timecolor=$TIME_COLOR --wrongcolor=$TIME_COLOR --greetercolor=$FG_COLOR \
    --timestr="%H:%M:%S" --timesize=50 --wrongsize=25 --greetersize=25 \
    --datestr="%a, %b %d" --datesize=25 \
    --line-uses-ring \
    --radius 20 --ring-width 10 \
    --veriftext="" --greetertext="" --noinputtext="" --wrongtext="Wrong password, try again" \
    --date-font="Roboto:style=Bold" --time-font="Roboto:style=Bold" \
    --wrong-font="Roboto:style=Bold" --greeter-font="Roboto:style=Bold"
}

lock () {
	dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop 2> /dev/null
	dbus-send --print-reply --dest=org.mpris.MediaPlayer2.mpv /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause 2> /dev/null
	
	if [[ $(mpc status) == *"[playing]"* ]]; then
	    STATUS='playing'
	    mpc -q pause
	fi

	pkill -u $USER -USR1 dunst
	
	if [[ $WM = 'openbox' ]]; then
		appearance
	else
		slock
	fi
	
	pkill -u $USER -USR2 dunst
	dbus-send --print-reply --dest=org.mpris.MediaPlayer2.mpv /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Play 2> /dev/null

	if [[ $STATUS = 'playing' ]]; then
		mpc -q play
	fi

}

show_help () {
	cat <<-EOF
	
	Usage:
	 lockscreen [OPTION]

	Avaible options:
	 -i, --image         Generate cache image
	 -h, --help          Show this help

	EOF
}

case $1 in
	-i|--image)
		genbg $2
		;;
	-h|--help)
		show_help
		;;
	*)
		lock
		;;
esac
