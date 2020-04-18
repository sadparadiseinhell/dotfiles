#!/bin/sh

if [[ -z $1 ]]; then
	THEME=$(echo -e 'dracula\ngruvbox\nnord\nmaterial\npalenight' | dmenu -p 'theme ')
	XRES="$HOME/dotfiles/colors/.colors/$THEME-colors"
elif [[ $1 = '-R' ]]; then
	THEME=$1
	XRES="$HOME/dotfiles/colors/.colors/$(cat $HOME/.currtheme)-colors"
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
	THEME=$(cat $HOME/.currtheme)
	COLOR=$(cat .colors/$THEME-colors | grep -m 1 'background' | awk '{print $2}')
	FILE='/tmp/color.png'
	
	convert -size 32x32 xc:$COLOR $FILE
	feh --bg-tile $FILE
}

restore () {
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
		wallpaper
		restore
		;;
	*)
		echo "What is '$1'?"
		exit 0
		;;
esac
