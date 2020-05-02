#!/bin/sh

desktop_name () {
	local NUM=$(( $(xprop -root -notype _NET_CURRENT_DESKTOP | sed -n '/.*=/s///p') + 1 ))
	echo $(xprop -root _NET_DESKTOP_NAMES | sed -ne 's/\"//g; s/\,//g; /.*=/s///p' | awk '{print $DESK}' DESK=$NUM)
}

window_name () {
	local WIN=$(echo $(xdotool getwindowfocus getwindowname))
	if [[ $WIN = 'Openbox' ]]; then
		echo '[ desktop ]'
	else
		echo $(xdotool getwindowfocus getwindowname)
	fi
}

case $1 in
	desk*)
		desktop_name
		;;
	win*)
		window_name
		;;
esac
