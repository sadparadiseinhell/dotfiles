#!/bin/bash

while true; do
MENU=$(echo -e 'show updates\nupdate system' | dmenu -p 'updates  ')
case $MENU in
	show*)
		if [[ -z $(checkupdates) ]]; then
			notify-send "$(echo -e 'no updates available\ntry later')" -t 2000
			exit 0
		else
			echo -e "$(checkupdates)" | dmenu -l 10
		fi

		SECONDMENU=$(echo -e 'no\nyes' | dmenu -p 'update?  ')
		if [[ $SECONDMENU = 'yes' ]]; then
			st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu
			break
		else 
			break
		fi
		;;
	update*)
		if [[ -z $(checkupdates) ]]; then
			notify-send "$(echo -e 'no updates available\ntry later')" -t 2000
			exit 0
		else
			st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu
			break
		fi
		
		;;
	*)
		break
		;;
esac
	exit 0
done