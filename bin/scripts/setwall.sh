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
	scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
	cp $HOME/.cache/lockscreen/resize-blur.png /dm/background.jpg
}

local_storage () {
	width=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $1}')
	height=$(xrandr --current | grep '*' | awk '{print $1}' | sed 's/x/ /' | awk '{print $2}')
	x=$(echo "($width-800)/2" | bc)
	y=$(echo "($height-600)/2" | bc)
	location=$(echo 800x600+$x+$y)
	walls=$(sxiv -t -o -r -b -g $location $WALLDIR | xargs)
	selwall=$(echo "$walls" | awk '{w = 1; for (--w; w >=0; w--){printf "%s\t",$(NF-w)}print ""}')

	[[ -z $(echo $selwall) ]] && exit 0
	
	#chosen=$(ls $WALLDIR | $LAUNCHER -i -p "Select wallpaper " )
	#[[ -z $chosen ]] && exit 0

	feh --bg-fill $(echo $selwall)
	notify-send "$(echo $selwall | sed 's/\// /g' | awk '{print $4}') set as wallpaper" -t 3200
	scripts/lock.sh -i $(cat .fehbg | tail -n 1 | awk '{print $4}' | sed s/\'//g)
	cp $HOME/.cache/lockscreen/resize-blur.png /dm/background.jpg
}

case $CHOSEN in
	Unsplash)
		unsplash
		;;
	Local*)
		local_storage
		;;
esac
