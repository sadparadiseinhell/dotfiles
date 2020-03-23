#!/bin/bash

while true; do
	WPLIGHT="$HOME/wallpapers/nord-light-solid.png"
	WPDARK="$HOME/wallpapers/nord-solid.png"
	TIME=$(date +%H)

	if [[ $TIME -lt 06 ]]; then
		feh --bg-scale $WPDARK
	elif [[ $TIME -lt 18 ]]; then
		feh --bg-scale $WPLIGHT
	elif [[ $TIME -lt 24 ]]; then
		feh --bg-scale $WPDARK
	fi
	sleep 10m
done
