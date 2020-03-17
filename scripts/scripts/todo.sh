#!/bin/bash

# Simple To-Do script for dmenu
# with 'add' and 'delete' options.

MAIN=$(echo -e 'add\nlist\ndelete all' | dmenu -p 'to-do  ')
TODO="$HOME/.todo/todo.txt"
LISTSEL="$HOME/.todo/listsel.txt"
ADDED="$HOME/.todo/added.txt"
SOUNDADDED='/usr/share/sounds/freedesktop/stereo/dialog-information.oga'

confirm () {
	CONFIRM=$(echo -e "no\nyes" | dmenu -p 'sure?  ')
}

if [[ $MAIN = 'add' ]]; then
	#echo '' | grep 0 | dmenu -p 'add todo  ' | gawk '{ print $0, strftime("[%Y-%m-%d]") }' >> $TODO
	if [[ -d $HOME/.todo/ ]]; then
		echo 'folder exists' &> /dev/null
	else
		mkdir $HOME/.todo/
	fi

	echo '' | grep 0 | dmenu -p 'add to-do  ' >> $ADDED

	if [[ -s $ADDED ]]; then
		notify-send "$(echo -e "to-do added:\n $(cat $ADDED)")" -t 2000
		paplay "$SOUNDADDED" 2>/dev/null &
		cat $ADDED >> $TODO
		rm $ADDED
	fi
	
elif [[ $MAIN = 'list' ]]; then
	echo -n $(echo -e "$(cat $TODO)" | grep -v -e '^$' | dmenu -p 'list  ') > $LISTSEL

	if [[ -s "$LISTSEL" ]]; then
		DELLIST=$(echo -e 'delete\nexit' | dmenu -p 'delete this')
		if [[ $DELLIST = 'delete' ]]; then
			DEL=$(cat $LISTSEL)
			sed -i "/$DEL/d" $TODO
			notify-send "$(echo -e "to-do deleted:\n $(cat $LISTSEL)")" -t 2000
		else
			exit 0
		fi
	fi
	rm $LISTSEL &> /dev/null

elif [[ $MAIN = 'delete all' ]]; then
	confirm
	if [[ $CONFIRM = 'no' ]]; then
		exit 0
	else
		cat /dev/null > $TODO
	fi

else
	exit 0
fi