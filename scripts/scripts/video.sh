#!/bin/bash

choice=$( (echo 1 | grep 0) | dmenu -p "paste a link to a video  ")
if [[ $choice == '' ]]; then
  notify-send 'no input' -t 1000 
  exit 1
else
  mpv --ytdl-format="[height=720]" $choice
fi
