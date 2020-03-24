#!/bin/bash

TIME=$(date +%H)
FILE='/tmp/color.png'
#POLARNIGHT='#2E3440 #3B4252 #434C5E #4C566A'
#SNOWSTORM='#D8DEE9 #E5E9F0 #ECEFF4'

while true; do
	if [[ $TIME -lt 06 ]]; then
		convert -size 32x32 xc:#2E3440 $FILE
	elif [[ $TIME -lt 18 ]]; then
		convert -size 32x32 xc:#D8DEE9 $FILE
	elif [[ $TIME -lt 21 ]]; then
		convert -size 32x32 xc:#3B4252 $FILE
	elif [[ $TIME -lt 24 ]]; then
		convert -size 32x32 xc:#2E3440 $FILE
	fi
	feh --bg-tile $FILE
	sleep 10m
done
