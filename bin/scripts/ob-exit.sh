#!/bin/sh

OPT=$(printf 'Cancel\nExit' | rofi -dmenu -width 260 -theme slate -location 0 -l 1 -columns 2 -i -p 'Are you sure you want to exit Openbox?'  )
case $OPT in
    Cancel)
        exit 0
        ;;
    Exit)
        openbox --exit
        ;;
esac