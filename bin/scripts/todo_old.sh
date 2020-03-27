#!/bin/bash

# Simple To-Do script for dmenu
# with 'add' and 'delete' options.

MAIN=$(echo -e 'add\nlist\ndelete all' | dmenu -p 'to-do ')
TODO="$HOME/.todo/todo.txt"
LISTSEL="$HOME/.todo/listsel.txt"
ADDED="$HOME/.todo/added.txt"
SOUNDADDED='/usr/share/sounds/freedesktop/stereo/dialog-information.oga'

if [[ $MAIN = 'add' ]]; then
	if [[ -d $HOME/.todo/ ]]; then
		echo 'folder exists' &> /dev/null
	else
		mkdir $HOME/.todo/
	fi

	echo '' | grep 0 | dmenu -p 'add to-do ' >> $ADDED

	if [[ -s $ADDED ]]; then
		notify-send "$(echo -e "to-do added:\n$(cat $ADDED)")" -t 2000
		paplay "$SOUNDADDED" 2>/dev/null &
		cat $ADDED >> $TODO
	fi
	rm $ADDED

elif [[ $MAIN = 'list' ]]; then
	if [[ -s $TODO ]]; then
		dmenu -l 5 -p 'list ' < $TODO > $LISTSEL

		if [[ -s "$LISTSEL" ]]; then
			DELLIST=$(echo -e 'no\nyes' | dmenu -p 'delete? ')
			if [[ $DELLIST = 'yes' ]]; then
				DEL=$(cat $LISTSEL)
				sed -i "/$DEL/d" $TODO
				notify-send "$(echo -e "to-do deleted:\n$(cat $LISTSEL)")" -t 2000
			fi
		fi
		rm $LISTSEL
	else
		echo '(´。＿。｀)' | dmenu -p "it's empty here "
	fi

elif [[ $MAIN = 'delete all' ]]; then
	CONFIRM=$(echo -e "no\nyes" | dmenu -p 'sure? ')
	if [[ $CONFIRM = 'no' ]]; then
		exit 0
	else
		cat /dev/null > $TODO
	fi

else
	exit 0
fi
