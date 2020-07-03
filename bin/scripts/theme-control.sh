#!/bin/sh

DUNST_PATH="$HOME/.colors/dunst/dunstrc-colored"
SCRIPT=awesome-menu.sh
THEME=oneline.rasi
WIDTH=557

function change {
	function dn {
		sed -i -e '0,/geometry/s/geometry = .*/geometry = "300x0-10+40"/' $DUNST_PATH
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &

		sed -i -e '0,/SCRIPT/s/SCRIPT=.*/SCRIPT=awesome-menu.sh/g' $0
		sed -i -e '0,/THEME/s/THEME=.*/THEME=oneline.rasi/g' $0
		sed -i -e '0,/WIDTH/s/WIDTH=.*/WIDTH=557/g' $0
		polybar-msg cmd quit
		$HOME/.config/polybar/2c/launch.sh
	}
	
	function mix {
		sed -i -e '0,/geometry/s/geometry = .*/geometry = "300x0-10+40"/' $DUNST_PATH
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &

		sed -i -e '0,/SCRIPT/s/SCRIPT=.*/SCRIPT=awesome-menu-mix.sh/g' $0
		sed -i -e '0,/THEME/s/THEME=.*/THEME=mix.rasi/g' $0
		sed -i -e '0,/WIDTH/s/WIDTH=.*/WIDTH=270/g' $0
		polybar-msg cmd quit
		$HOME/.config/polybar/2c/launch.sh
	}
	
	function slate {
		sed -i -e '0,/geometry/s/geometry = .*/geometry = "300x0-10+10"/' $DUNST_PATH
		killall dunst
		dunst -config $HOME/.colors/dunst/dunstrc-colored &

		sed -i -e '0,/SCRIPT/s/SCRIPT=.*/SCRIPT=bottom-menu.sh/g' $0
		sed -i -e '0,/THEME/s/THEME=.*/THEME=slate.rasi/g' $0
		sed -i -e '0,/WIDTH/s/WIDTH=.*/WIDTH=280/g' $0
		polybar-msg cmd quit
		$HOME/.config/polybar/launch.sh
	}
	
	dn='Day/Night'
	mix='Mix'
	slate='Slate'
		
	options="$dn\n$mix\n$slate"

	lines=$(echo -e $options | wc -l)
	[ $lines -gt 4 ] && lines=4

	opt="$(echo -e "$options" | rofi -show -theme $THEME -width $WIDTH -l $lines -i -dmenu -selected-row 0 -p 'Theme:')"
	
	case $opt in
		$dn)
			dn
			;;
		$mix)
			mix
			;;
		$slate)
			slate
			;;
	esac
}

case $1 in
	-c)
		change
		;;
	-r)
		rofi -show run -theme $THEME
		;;
	-g)
		$HOME/scripts/$SCRIPT -g
		;;
	-s)
		$HOME/scripts/$SCRIPT -s
		;;
	-p)
		$HOME/scripts/$SCRIPT -p
		;;
	-m)
		$HOME/scripts/$SCRIPT -mc
		;;
	-w)
		rofi -show window -theme $THEME
		;;
esac