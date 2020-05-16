#!/bin/sh

WIDTH=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $1}')
HEIGHT=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $2}')

ACTIVEDESK=$(wmctrl -d | grep '*' | awk '{print $1}')
WINDOWS=$(wmctrl -l | grep " $ACTIVEDESK " | awk '{print $1}')
NUMWIN=$(echo $WINDOWS | wc -w)
ELEMENTHEIGHT=70
WINDOWTITLE=30

if [[ -z $1 ]]; then
	GAPS=10
else
	GAPS=$1
fi

one_win () {
	xdotool getactivewindow windowsize $(( $WIDTH - ($GAPS * 2) )) $(( $HEIGHT - $ELEMENTHEIGHT - ($GAPS * 2) )) windowmove $GAPS $GAPS
}

two_win () {
	xdotool windowsize $(echo $WINDOWS | awk '{print $1}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT - ($GAPS * 2) - $ELEMENTHEIGHT )) \
	windowmove $(echo $WINDOWS | awk '{print $1}') $GAPS $GAPS
	
	xdotool windowsize $(echo $WINDOWS | awk '{print $2}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT - ($GAPS * 2) - $ELEMENTHEIGHT )) \
	windowmove $(echo $WINDOWS | awk '{print $2}') $(( $WIDTH / 2 + ($GAPS / 2) )) $GAPS
}

three_win () {
	xdotool windowsize $(echo $WINDOWS | awk '{print $1}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT - ($GAPS * 2) - $ELEMENTHEIGHT )) \
	windowmove $(echo $WINDOWS | awk '{print $1}') $GAPS $GAPS

	xdotool windowsize $(echo $WINDOWS | awk '{print $2}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - ($WINDOWTITLE - 2) )) \
	windowmove $(echo $WINDOWS | awk '{print $2}') $(( $WIDTH / 2 + ($GAPS / 2) )) $GAPS
	
	xdotool windowsize $(echo $WINDOWS | awk '{print $3}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - $ELEMENTHEIGHT)) \
	windowmove $(echo $WINDOWS | awk '{print $3}') $(( $WIDTH / 2 + ($GAPS / 2) )) $(( $HEIGHT / 2 + ($GAPS - ($GAPS / 2)) ))
}

four_win () {
	xdotool windowsize $(echo $WINDOWS | awk '{print $1}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - ($WINDOWTITLE - 2) )) \
	windowmove $(echo $WINDOWS | awk '{print $1}') $GAPS $GAPS

	xdotool windowsize $(echo $WINDOWS | awk '{print $2}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - $ELEMENTHEIGHT)) \
	windowmove $(echo $WINDOWS | awk '{print $2}') $GAPS $(( $HEIGHT / 2 + ($GAPS - ($GAPS / 2)) ))

	xdotool windowsize $(echo $WINDOWS | awk '{print $3}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - ($WINDOWTITLE - 2) )) \
	windowmove $(echo $WINDOWS | awk '{print $3}') $(( $WIDTH / 2 + ($GAPS / 2) )) $GAPS
	
	xdotool windowsize $(echo $WINDOWS | awk '{print $4}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - $ELEMENTHEIGHT)) \
	windowmove $(echo $WINDOWS | awk '{print $4}') $(( $WIDTH / 2 + ($GAPS / 2) )) $(( $HEIGHT / 2 + ($GAPS - ($GAPS / 2)) ))
}

case $NUMWIN in
	1)
		one_win
		;;
	2)
		two_win
		;;
	3)
		three_win
		;;
	4)
		four_win
		;;
esac
