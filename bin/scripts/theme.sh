#!/bin/sh

if [[ -z $1 ]]; then
	CHOICE=$(echo -e 'dracula\ngruvbox\nnord\nmaterial\npalenight' | dmenu -p 'theme ')
else
	CHOICE=$1
fi

XFILE="$HOME/dotfiles/x/.Xresources"
WALLFILE="$HOME/dotfiles/bin/scripts/wallpaper.sh"
DUNSTFILE="$HOME/dotfiles/configs/.config/dunst/dunstrc"

change_theme () {
	sed -i "/#include/c #include \"/home/ma/.colors/$CHOICE-colors\"" $XFILE
	sed -i "/source/c source $HOME/.colors/$CHOICE.sh" $WALLFILE
	killall wallpaper.sh 2> /dev/null
	$HOME/scripts/wallpaper.sh &
	xrdb -load $XFILE
	killall dunst 2> /dev/null
	killall dwm
	sleep 0.5
	cat dotfiles/colors/.colors/dunst/dunst-$CHOICE > $DUNSTFILE
	dunst 2> /dev/null &
	sleep 0.5
	echo $CHOICE > $HOME/.curtheme
}

restore () {
	xrdb -load $XFILE
	killall dwm
	echo $CHOICE > $HOME/.curtheme
}

case $CHOICE in
	d*|g*|n*|m*|p*)
	change_theme
	notify-send 'current theme:' "$CHOICE"
		;;
	-R)
	CHOICE=$(cat $HOME/.curtheme)
	restore
		;;
	*)
	echo "What is '$1'?"
	exit 0
		;;
esac
