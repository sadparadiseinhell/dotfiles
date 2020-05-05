#!/bin/sh

source $HOME/scripts/launcher.sh

artist() {
	lines(){ mpc list artist | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list artist | sort -f | $LAUNCHER -i -p "Artists " -l $lines
}

a_album() {
	artist="$1"
	lines(){ mpc list album artist "$artist" | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list album artist "$artist" | sort -f | $LAUNCHER -i -p "Albums " -l $lines
}

album() {
	lines(){ mpc list album | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list album | sort -f | $LAUNCHER -i -p "Album " -l $lines
}

song() {
	lines(){ mpc list title | wc -l ; }
	lines=$(lines)
	[ "$(lines)" -gt 10 ] && lines=10
	mpc list title | sort -f | $LAUNCHER -i -p "Song " -l $lines
}

MODE=$(printf "Library\nAlbum\nSong" | $LAUNCHER -i -p "Choose mode " -l 3)

case "$MODE" in
	Library)
		artist=$(artist)
		[ ! "$artist" ] && exit
		album=$(a_album "$artist")
		[ ! "$album" ] && exit
		mpc clear > /dev/null
		mpc find artist "$artist" album "$album" | mpc add
		$HOME/scripts/musicctrl.sh play
		;;
	Song) 
		song=$(song)		
		[ ! "$song" ] && exit
		mpc clear > /dev/null
		mpc search title "$song" | mpc add
		$HOME/scripts/musicctrl.sh play
		;;
	Album)
		album=$(album)
		[ ! "$album" ] && exit
		mpc clear > /dev/null
		mpc find album "$album" | mpc add
		$HOME/scripts/musicctrl.sh play
		;;
esac

