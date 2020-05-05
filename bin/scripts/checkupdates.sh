#!/bin/sh

source $HOME/scripts/launcher.sh

MENU=$(printf 'Show updates\nUpdate system' | $LAUNCHER -i -p 'Updates ')
HEIGHT=$(checkupdates | wc -l)
if [[ $HEIGHT -gt 8 ]]; then
	HEIGHT='8'
fi

show_updates () {
	if [[ -z $(checkupdates) ]]; then
		notify-send "$(printf 'No updates available\nPls try again later')" -t 2000
		exit 0
	else
		echo "$(checkupdates)" | $LAUNCHER -l $HEIGHT -i -p 'list '
	fi
	
	SECONDMENU=$(printf 'No\nYes' | $LAUNCHER -i -p 'Update? ')
	
	if [[ $SECONDMENU = 'Yes' ]]; then
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
		notify-send "$(printf 'No updates available\nPls try again later')" -t 2000
	else
		st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu --noconfirm
		notify-send 'Update completed successfully'
	fi
	exit 0
}

while true; do
	case $MENU in
		Show*)
			show_updates
			;;
		Update*)
			update_system
			;;
		*)
			exit 0
			;;
	esac
done