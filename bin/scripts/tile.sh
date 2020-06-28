#!/bin/sh

WIDTH=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $1}')
HEIGHT=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $2}')

ACTIVEDESK=$(wmctrl -d | grep '*' | awk '{print $1}')
WINDOWS=$(wmctrl -l | grep " $ACTIVEDESK " | awk '{print $1}')
WINNUM=$(echo $WINDOWS | wc -w)
PANELID=$(wmctrl -l | grep ' -1 ' | awk '{print $1}')
TITLEHEIGHT=30
PANELHEIGHT=30

if [[ -z $1 || $1 = *[aA-zZ] ]]; then
	GAPS=10
else
	GAPS=$1
fi

if [[ -z $PANELID ]]; then
	HGAPS=$GAPS
	PANELHEIGHT=28
else
	PANELGEOMETRY=$(xdotool getwindowgeometry $PANELID | grep 'Position' | awk '{print $2}')
	PANELPOSITION=$(( $HEIGHT - $(echo $PANELGEOMETRY | sed -r 's/.*,//') ))
	if [[ $PANELGEOMETRY -lt '0,50' ]]; then
		HGAPS=$(( $GAPS + $PANELHEIGHT ))
		HEIGHT=$(( $HEIGHT - $PANELHEIGHT + 2 ))
	else
		HGAPS=$GAPS
		PANELHEIGHT=$(( $PANELHEIGHT + $PANELPOSITION - 2 ))
	fi
fi

one_win () {
	xdotool getactivewindow windowsize $(( $WIDTH - ($GAPS * 2) )) $(( $HEIGHT - $PANELHEIGHT - ($GAPS * 2) )) windowmove $GAPS $HGAPS
}

focus_fullscreen () {
	xdotool getwindowfocus windowsize $(( $WIDTH - ($GAPS * 2) )) $(( $HEIGHT - $PANELHEIGHT - ($GAPS * 2) )) windowmove $GAPS $HGAPS
}

two_win () {
	xdotool windowsize $(echo $WINDOWS | awk '{print $1}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT - ($GAPS * 2) - $PANELHEIGHT )) \
	windowmove $(echo $WINDOWS | awk '{print $1}') $GAPS $HGAPS
	
	xdotool windowsize $(echo $WINDOWS | awk '{print $2}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT - ($GAPS * 2) - $PANELHEIGHT )) \
	windowmove $(echo $WINDOWS | awk '{print $2}') $(( $WIDTH / 2 + ($GAPS / 2) )) $HGAPS
}

three_win () {
	xdotool windowsize $(echo $WINDOWS | awk '{print $1}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT - ($GAPS * 2) - $PANELHEIGHT )) \
	windowmove $(echo $WINDOWS | awk '{print $1}') $GAPS $HGAPS

	xdotool windowsize $(echo $WINDOWS | awk '{print $2}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - ($TITLEHEIGHT - 2) )) \
	windowmove $(echo $WINDOWS | awk '{print $2}') $(( $WIDTH / 2 + ($GAPS / 2) )) $HGAPS
	
	xdotool windowsize $(echo $WINDOWS | awk '{print $3}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - $PANELHEIGHT)) \
	windowmove $(echo $WINDOWS | awk '{print $3}') $(( $WIDTH / 2 + ($GAPS / 2) )) $(( $HEIGHT / 2 + ($HGAPS - ($GAPS / 2)) ))
}

four_win () {
	xdotool windowsize $(echo $WINDOWS | awk '{print $1}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - ($TITLEHEIGHT - 2) )) \
	windowmove $(echo $WINDOWS | awk '{print $1}') $GAPS $HGAPS

	xdotool windowsize $(echo $WINDOWS | awk '{print $2}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - $PANELHEIGHT)) \
	windowmove $(echo $WINDOWS | awk '{print $2}') $GAPS $(( $HEIGHT / 2 + ($HGAPS - ($GAPS / 2)) ))

	xdotool windowsize $(echo $WINDOWS | awk '{print $3}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - ($TITLEHEIGHT - 2) )) \
	windowmove $(echo $WINDOWS | awk '{print $3}') $(( $WIDTH / 2 + ($GAPS / 2) )) $HGAPS
	
	xdotool windowsize $(echo $WINDOWS | awk '{print $4}') \
	$(( $WIDTH / 2 - $GAPS - ($GAPS / 2) )) \
	$(( $HEIGHT / 2 - ($GAPS + ($GAPS / 2)) - $PANELHEIGHT)) \
	windowmove $(echo $WINDOWS | awk '{print $4}') $(( $WIDTH / 2 + ($GAPS / 2) )) $(( $HEIGHT / 2 + ($HGAPS - ($GAPS / 2)) ))
}

centered () {
	if [[ $PANELGEOMETRY -lt '0,50' ]]; then
		HEIGHT=$(( 90 + PANELHEIGHT ))
	else
		HEIGHT=90
	fi

	xdotool getactivewindow windowsize 1200 800 windowmove 240 $HEIGHT
}

case $1 in
	-c)
		centered
		exit
		;;
	-f)
		focus_fullscreen
		exit
		;;
esac

case $WINNUM in
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
