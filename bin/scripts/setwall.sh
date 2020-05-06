#!/bin/sh

source $HOME/scripts/launcher.sh

WALLDIR="$HOME/wallpapers"
CHOSEN=$(echo -e "Unsplash\nLocal storage" | $LAUNCHER -l 2 -i -p "Select wallpaper " )

unsplash () {
	pic="$HOME/.cache/wallpaper_unsplash.jpg"
	chosen=$($LAUNCHER -i -dmenu -l 0 -theme slate -p 'Enter search term: ')
	
	if [[ -z $chosen ]]; then
		exit 0
	elif [[ $chosen = 'daily' ]]; then
		wget -O $pic https://source.unsplash.com/daily
	elif [[ $chosen = 'random' ]]; then
		wget -O $pic https://source.unsplash.com/random/1920x1080
	else
		p="$(echo "?$chosen" | sed -e 's/ /\,/g')"
		wget -O $pic https://source.unsplash.com/featured/1920x1080/$p
	fi
	
	feh --bg-fill $pic
	notify-send "New wallpaper set" -t 3200
	exec scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
}

local_storage () {
	chosen=$(ls $WALLDIR | $LAUNCHER -i -p "Select wallpaper " )
	
	[[ -z $chosen ]] && exit 0

	feh --bg-fill $WALLDIR/$chosen
	echo $WALLDIR/$chosen > $HOME/.currwall
	notify-send "$chosen set as wallpaper" -t 3200
	exec scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
}

case $CHOSEN in
	Unsplash)
		unsplash
		;;
	Local*)
		local_storage
		;;
esac
