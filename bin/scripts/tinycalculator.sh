#!/bin/sh

while true; do
	MAIN=$(echo | grep 0 | dmenu -p 'enter an example ')
	if [[ -z $MAIN ]]; then
		exit 0
	fi
	RES=$(echo $MAIN | bc | dmenu -p 'result ')
	if [[ -z $RES ]]; then
		exit 0
	fi
done