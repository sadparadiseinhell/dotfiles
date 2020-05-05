#!/bin/sh

TIME=$(date '+%H')

case $TIME in
	0[6-9]|1[0-2])
		notify-send -t 3000 'Good morning'
		;;
	1[3-6])
		notify-send -t 3000 'Good afternoon'
		;;
	1[7-9]|2[0-2])
		notify-send -t 3000 'Good evening'
		;;
	23|0[0-5])
		notify-send -t 3000 'Good night'
		;;
esac
