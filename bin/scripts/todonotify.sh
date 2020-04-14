#!/bin/sh

LIST="$HOME/.todo.txt"

if [[ -s $LIST ]]; then
	notify-send 'to-do:' "$(cat $LIST)" -u critical -t 3500
fi
