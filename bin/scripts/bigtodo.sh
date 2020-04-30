#!/bin/sh 

#
# Source: https://github.com/simonvic/dotfiles
#

TODOFILE=$HOME/.todolist
DONESYMBOL=☒
TODOSYMBOL=☐
DELETEDSYMBOL=✕

ICON=""

MAXLENGTH=10

URGENCY=normal

TIMEOUT=8000

ID=2597


touch $TODOFILE

printHeader() {
echo '
████████╗ ██████╗       ██████╗  ██████╗ 
╚══██╔══╝██╔═══██╗      ██╔══██╗██╔═══██╗
   ██║   ██║   ██║█████╗██║  ██║██║   ██║
   ██║   ██║   ██║╚════╝██║  ██║██║   ██║
   ██║   ╚██████╔╝      ██████╔╝╚██████╔╝
   ╚═╝    ╚═════╝       ╚═════╝  ╚═════╝ 
'
}

printUsage () {
	echo -e "Usage: todo [options]

Options:
 help\tshow this help
		
Query commands:
 list\t[done|todo|deleted] [name] List with filters
 done\tList things done
 todo\tList things still to do
 del\tList things cancelled
	
Edit commands:
 new	<name>\tAdd a new thing to do with name <name>
 do\t<id>\tMark it done
 undo\t<id>\tMark it undone
 delete\t<id>\tMark it deleted
 edit\t\tEdit manually the todo list
	
Other:
 notification\tShow todo list in a notification"
}

getCount () {
	case $1 in
		done)
			grep -e "$DONESYMBOL" $TODOFILE | grep "$2" | wc -l
			;;
		todo)
			grep -e "$TODOSYMBOL" $TODOFILE | grep "$2" | wc -l
			;;
		deleted)
			grep -e "$DELETEDSYMBOL" $TODOFILE | grep "$2" | wc -l
			;;
		*)
			grep -e "$1" $TODOFILE | wc -l
			;;
	esac
}

list () {
	case $1 in
		done)
			grep -e "$DONESYMBOL" $TODOFILE | grep "$2"
			;;
		todo)
			grep -e "$TODOSYMBOL" $TODOFILE | grep "$2"
			;;
		del)
			grep -e "$DELETEDSYMBOL" $TODOFILE | grep "$2"
			;;
		*)
			if [[ -s $TODOFILE ]]; then
				grep -e "$1" $TODOFILE
			else
				echo -e "It's empty here"
			fi
			;;
	esac
}

addNew () {
	if [ -z "$1" ]; then
		printUsage
	else
		NEWID=$((`tail -n 1 $TODOFILE | cut -d "[" -f2 | cut -d "]" -f1` + 1)) 
		echo "$TODOSYMBOL [$NEWID] "${@:2}"" >> $TODOFILE
	fi
}


mark () {
	if [ -z "$2" ]; then
		printUsage
	else
		case $1 in
			done)
				sed -i "s/^\($DELETEDSYMBOL\|$TODOSYMBOL\) \[$2\]/$DONESYMBOL \[$2\]/g" $TODOFILE
				;;
			todo)
				sed -i "s/^\($DELETEDSYMBOL\|$DONESYMBOL\) \[$2\]/$TODOSYMBOL \[$2\]/g" $TODOFILE
				;;
			deleted)
				sed -i "s/^\($TODOSYMBOL\|$DONESYMBOL\) \[$2\]/$DELETEDSYMBOL \[$2\]/g" $TODOFILE
				;;
			*)
				printUsage
				;;
		esac
	fi
}

editFile () {
	xdg-open $TODOFILE &
}


buildBar () {
	$HOME/scripts/drawbar.sh $1 $2 $3
}

sendNotification () {
	DONECOUNT=`getCount done $2`
	TODOCOUNT=`getCount todo $2`
	DELETEDCOUNT=`getCount deleted $2`
	TOTALCOUNT=$(grep -e "$1" $TODOFILE | grep -v "$DELETEDSYMBOL" | wc -l)
	ALLCOUNT=`getCount`
	
	SUMMARY="$TODOCOUNT todo | $DONECOUNT done | $DELETEDCOUNT deleted | $ALLCOUNT total
"
	
	LENGTH=`getCount $1 $2`
	if [ $LENGTH -ge $MAXLENGTH ]; then
		BODY="`list $1 $2 | head -$MAXLENGTH`
... $(($LENGTH - $MAXLENGTH)) more
"
	else
		BODY="`list $1 $2`
"
	fi
	
	if [[ $TODOCOUNT -ne 0 ]] || [[ -s $TODOFILE ]]; then
		TODOPERCENT=$((DONECOUNT * 100 / TOTALCOUNT))
		BODY+="
`buildBar 5 $TODOPERCENT false` $TODOPERCENT%"
	else
		TODOPERCENT='100'
		BODY+="
`buildBar 5 100 true` --%"
	fi

	dunstify -C "$ID"  && dunstify -i "$ICON" -r "$ID" -t "$TIMEOUT" -u "$URGENCY" "$SUMMARY" "$BODY"
}

case $1 in
	list)
		#printHeader
		list $2 $3
	;;
	count)
		getCount $2 $3
	;;
	new)
		addNew $@
	;;
	do)
		mark done $2
	;;
	undo)
		mark todo $2
	;;
	delete)
		mark deleted $2
	;;
	edit)
		editFile
	;;
	notification)
		sendNotification $2 $3
	;;
	--help)
		#printHeader
		printUsage
	;;
	*)
		printHeader
		list todo
	;;
esac
