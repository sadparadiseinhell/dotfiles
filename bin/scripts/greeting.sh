#!/bin/bash

TIME=$(date '+%H')

sleep 4

if [ $TIME -lt 05 ]; then
	notify-send -t 3000 'good night'
elif [ $TIME -lt 12 ]; then
	notify-send -t 3000 'good morning'
elif [ $TIME -lt 16 ]; then
	notify-send -t 3000 'good afternoon'
elif [ $TIME -lt 23 ]; then
	notify-send -t 3000 'good evening'
else
	notify-send -t 3000 'good night'
fi
