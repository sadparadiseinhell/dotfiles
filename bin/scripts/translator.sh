#!/bin/bash

MENU=$(echo -e 'english to russian\nrussian to english' | dmenu -p 'translator ')
if [[ -z $MENU ]]; then
	exit 0
else
	INPUT=$(echo | grep 0 | dmenu -p 'input ')
	if [[ -z $INPUT ]]; then
		exit 0
	else
		case $MENU in
			'english to russian')
			trans -no-auto -b :ru "$INPUT" | dmenu -l 5 -p 'result ' | xclip -selection clipboard
				;;
			'russian to english')
			trans -no-auto -b :en "$INPUT" | dmenu -l 5 -p 'result ' | xclip -selection clipboard
				;;
			*)
			exit 0
				;;
		esac
	fi
fi