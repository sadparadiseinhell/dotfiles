#!/bin/sh

source $HOME/scripts/launcher.sh

while true; do
	MAIN=$(echo | grep 0 | $LAUNCHER -i -p 'Enter an example ')
	if [[ -z $MAIN ]]; then
		exit 0
	fi
	RES=$(echo $MAIN | bc | $LAUNCHER -i -p 'Result ')
	if [[ -z $RES ]]; then
		exit 0
	fi
done