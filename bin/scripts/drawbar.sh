#!/bin/sh

#
# Source: https://github.com/simonvic/dotfiles
#

STEPS=$1
LENGHT=$2
DRAWEMPTY=$3

FULLCHAR="█"
MIDCHAR0="▆"
MIDCHAR1="▅"
MIDCHAR2="▃"
MIDCHAR3="▁"
MIDPOINT=""
EMPTYCHAR="░"


# Line
#FULLCHAR="━"
#MIDCHAR0="╾"
#MIDCHAR1="╾"
#MIDCHAR2="╾"
#MIDCHAR3="╾"
#MIDPOINT=""
#EMPTYCHAR="─"

# Using braille
#FULLCHAR="⣿"
#MIDCHAR0="⡷"
#MIDCHAR1="⡇"
#MIDCHAR2="⠆"
#MIDCHAR3="⠂"
#MIDPOINT=""
#EMPTYCHAR="⠀"

if [[ $DRAWEMPTY = false ]]; then
	BAR=$(seq -s $FULLCHAR 0 $STEPS $LENGHT | sed 's/[0-9]//g') 
	if [ $(( ($LENGHT-4) % $STEPS )) -eq 0 ]; then
		MIDBAR=$MIDCHAR0
	elif [ $(( ($LENGHT-3) % $STEPS )) -eq 0 ]; then
		MIDBAR=$MIDCHAR1
	elif [ $(( ($LENGHT-2) % $STEPS )) -eq 0 ]; then
		MIDBAR=$MIDCHAR2
	elif [ $(( ($LENGHT-1) % $STEPS )) -eq 0 ]; then
		MIDBAR=$MIDCHAR3
	fi

EMPTYBAR=$(seq -s $EMPTYCHAR $(( ((100-$LENGHT) / $STEPS ) +1 )) | sed 's/[0-9]//g')
FINALBAR="$BAR$MIDBAR$MIDPOINT$EMPTYBAR"

elif [[ $DRAWEMPTY = true ]]; then
	FINALBAR="$(seq -s $EMPTYCHAR $(($LENGHT/$STEPS +1)) | sed 's/[0-9]//g')"
fi

echo $FINALBAR
