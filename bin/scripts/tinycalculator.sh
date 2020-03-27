#!/bin/bash

while true; do
	MAIN=$(echo | grep 0 | dmenu -p 'enter an example ')
	if [[ -z $MAIN ]]; then
		break
	fi
	RES=$(echo $MAIN | bc | dmenu -p 'result ')
	if [[ -z $RES ]]; then
		break
	fi
done