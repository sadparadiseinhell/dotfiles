#!/bin/bash

dbus-send --print-reply --dest=org.mpris.MediaPlayer2.spotify /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Stop
dbus-send --print-reply --dest=org.mpris.MediaPlayer2.mpv /org/mpris/MediaPlayer2 org.mpris.MediaPlayer2.Player.Pause
mpc pause
pkill -u $USER -USR1 dunst

slock

pkill -u $USER -USR2 dunst
#mpc play
