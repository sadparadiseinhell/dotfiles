#!/bin/sh

if [[ -z $1 ]]; then
	THEME=$(ls -p .colors | grep -v / | dmenu -p 'theme ')
	XRES="$HOME/dotfiles/colors/.colors/$THEME"
else
	THEME=$1
fi

DUNSTFILE="$HOME/dotfiles/configs/.config/dunst/dunstrc"

change_theme () {
	echo $THEME > $HOME/.currtheme
	xrdb -load $XRES
	killall dunst 2> /dev/null
	killall dwm
	cat dotfiles/colors/.colors/dunst/dunst-$THEME > $DUNSTFILE
}

wallpaper () {
	COLOR=$(cat .colors/$THEME | grep -m 1 'background' | awk '{print $2}')
	FILE='/tmp/color.png'
	
	convert -size 32x32 xc:$COLOR $FILE
	feh --bg-tile $FILE
}

restore () {
	if [[ -e $HOME/.currtheme ]]; then
		THEME=$(cat $HOME/.currtheme)
		XRES="$HOME/dotfiles/colors/.colors/$(cat $HOME/.currtheme)"
	else
		THEME='nord'
		XRES="$HOME/dotfiles/x/.Xresources"
	fi
	
	xrdb -load $XRES
	killall dwm
}

case $THEME in
	d*|g*|n*|m*|p*)
		change_theme
		wallpaper
		notify-send 'current theme:' "$THEME"
		;;
	-R)
		restore
		wallpaper
		;;
	*)
		echo "What is '$1'?"
		exit 0
		;;
esac
