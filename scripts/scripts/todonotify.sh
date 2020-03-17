#!/bin/bash

LIST="$HOME/.todo/todo.txt"

if [[ -s "$LIST" ]]; then
	notify-send "$(echo -e "to-do:\n$(cat $LIST)")" -u critical -t 3500
else
	exit 0
fi
