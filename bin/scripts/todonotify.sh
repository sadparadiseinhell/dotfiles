#!/bin/bash

LIST="$HOME/.todo.txt"

if [[ -s $LIST ]]; then
	sleep 8
	notify-send 'to-do:' "$(cat $LIST)" -u critical -t 3500
fi
