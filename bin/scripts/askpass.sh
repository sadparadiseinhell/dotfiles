#!/bin/sh

source $HOME/scripts/theme-control.sh

rofi -dmenu\
    -password\
    -i\
    -p "Password:"\
    -l 0\
    -theme $THEME