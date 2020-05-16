#!/bin/sh

ROFITHEME="rofi -theme apps.rasi"

chromium=''
subl3=''
telegram=''
spotify=''
discord=''

options="$chromium\n$subl3\n$telegram\n$spotify\n$discord"
opt="$(echo -e "$options" | $ROFITHEME -p '' -dmenu -selected-row 0)"
case $opt in
	$chromium) chromium;;
	$subl3) subl3;;
	$telegram) telegram-desktop;;
	$spotify) spotify;;
	$discord) discord;;
esac