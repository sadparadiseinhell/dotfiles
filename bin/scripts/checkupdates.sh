#!/bin/sh

MENU=$(echo -e 'show updates\nupdate system' | dmenu -p 'updates ')
HEIGHT=$(checkupdates | wc -l)

show_updates () {
	if [[ -z $(checkupdates) ]]; then
		notify-send "$(echo -e 'no updates available\npls try again later')" -t 2000
		exit 0
	else
		echo "$(checkupdates)" | dmenu -l $HEIGHT
	fi
	
	SECONDMENU=$(echo -e 'no\nyes' | dmenu -p 'update? ')
	
	if [[ $SECONDMENU = 'yes' ]]; then
		st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu --noconfirm
		if [[ $? -eq 0 ]]; then
			notify-send 'update completed successfully'
		else
			exit 0
		fi
		exit 0
	else
		exit 0
	fi
}

update_system () {
	if [[ -z $(checkupdates) ]]; then
		notify-send "$(echo -e 'no updates available\npls try again later')" -t 2000
	else
		st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu --noconfirm
		notify-send 'update completed successfully'
	fi
	exit 0
}

while true; do
	case $MENU in
		show*)
			show_updates
			;;
		update*)
			update_system
			;;
		*)
			exit 0
			;;
	esac
done