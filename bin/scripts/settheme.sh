#!/bin/sh

CHOICE=$(echo -e 'dracula\ngruvbox\nnord' | dmenu -p 'theme ')
XFILE="$HOME/dotfiles/x/.Xresources"
BARFILE="$HOME/dotfiles/bin/scripts/statusbar.sh"
WALLFILE="$HOME/dotfiles/bin/scripts/wallpaper.sh"
DUNSTFILE="$HOME/dotfiles/configs/.config/dunst/dunstrc"
VIMFILE="$HOME/dotfiles/configs/.config/nvim/init.vim"

refresh () {
	killall statusbar.sh
	$HOME/scripts/statusbar.sh
	killall wallpaper.sh
	$HOME/scripts/wallpaper.sh &
	xrdb -load $HOME/.Xresources
	killall dunst
	killall dwm
	sleep 1
}

case $CHOICE in
	dracula)
	sed -i '/#include/c #include "/home/ma/.colors/dracula-colors"' $XFILE
	sed -i '/source/c source $HOME/.colors/dracula.sh' $BARFILE
	sed -i '/source/c source $HOME/.colors/dracula.sh' $WALLFILE
	sed -ie '30,$s/nord/dracula/; 30,$s/gruvbox/dracula/' $VIMFILE
	refresh
	cat dotfiles/colors/.colors/dunst/dunst-dracula > $DUNSTFILE
	dunst 2> /dev/null &
	sleep 1
	notify-send 'current theme:' 'dracula'
		;;
	gruvbox)
	sed -i '/#include/c #include "/home/ma/.colors/gruvbox-colors"' $XFILE
	sed -i '/source/c source $HOME/.colors/gruvbox.sh' $BARFILE
	sed -i '/source/c source $HOME/.colors/gruvbox.sh' $WALLFILE
	sed -ie '30,$s/nord/gruvbox/; 30,$s/dracula/gruvbox/' $VIMFILE
	refresh
	cat dotfiles/colors/.colors/dunst/dunst-gruvbox > $DUNSTFILE
	dunst 2> /dev/null &
	sleep 1
	notify-send 'current theme:' 'gruvbox'
		;;
	nord)
	sed -i '/#include/c #include "/home/ma/.colors/nord-colors"' $XFILE
	sed -i '/source/c source $HOME/.colors/nord.sh' $BARFILE
	sed -i '/source/c source $HOME/.colors/nord.sh' $WALLFILE
	sed -ie '30,$s/gruvbox/nord/; 30,$s/dracula/nord/' $VIMFILE
	refresh
	cat dotfiles/colors/.colors/dunst/dunst-nord > $DUNSTFILE
	dunst 2> /dev/null &
	sleep 1
	notify-send 'current theme:' 'nord'
		;;
	*)
	exit 0
		;;
esac
