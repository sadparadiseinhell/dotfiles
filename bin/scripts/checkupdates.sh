#!/bin/sh

source $HOME/scripts/launcher.sh

MENU=$(printf 'Show updates\nUpdate system' | $LAUNCHER -i -p 'Updates ')
NUM=$(checkupdates | wc -l)
if [[ $NUM -gt 8 ]]; then
	HEIGHT='8'
else
	HEIGHT=$NUM
fi

show_updates () {
	if [[ -z $(checkupdates) ]]; then
		notify-send "$(printf 'No updates available\nPls try again later')" -t 2000
		exit 0
	else
		list=$(echo "$(checkupdates)" | $LAUNCHER -l $HEIGHT -i -p "$(echo "$NUM") updates " )
	fi
	
	[[ -z $list ]] && exit 0

	second_menu=$(printf 'No\nYes' | $LAUNCHER -i -p 'Update? ')
	
	if [[ $second_menu = 'Yes' ]]; then
		st -T 'update' -c 'updates' -g 75x25 -e sudo pacman -Syu --noconfirm
		if [[ $? -eq 0 ]]; then
			notify-send 'Update completed successfully'
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
