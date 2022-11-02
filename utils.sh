#!/bin/bash

# helper functions for my scripts, to not double the code


help_file=$(mktemp)

_at_exit()
{
	if [ "$(type -t at_exit 2>/dev/null)" = function ]; then
		at_exit
	fi
	rm -f $help_file
}
trap _at_exit EXIT

help()
{
	comp=$1
	num=$2
	shift
	shift
	num_of_prog_args=$#

	cat - >$help_file

	if test x$1 = x-h -o x$1 = x--help ||
			test $num_of_prog_args -$comp $num; then
		# help requested, or ther was an error in
		# arg check, either way print help string
		cat $help_file
		echo
		# exit won't work here, so we commit sepuku
		kill $$ &>/dev/null
	fi
}

print_help()
{
	cat $help_file
}


## ==========================================================================
#                            ____/ /____ _ / /_ ___
#                           / __  // __ `// __// _ \
#                          / /_/ // /_/ // /_ /  __/
#                          \__,_/ \__,_/ \__/ \___/
## ==========================================================================


displaytime()
{
	local T=$1
	local D=$((T/60/60/24))
	local H=$((T/60/60%24))
	local M=$((T/60%60))
	local S=$((T%60))
	(( D > 0 )) && printf '%02dd' $D
	(( D > 0 || H > 0 )) && printf '%02d:' $H
	(( D > 0 || H > 0 || M > 0 )) && printf '%02d:' $M
	printf '%02d\n' $S
}

## ==========================================================================
#   Returns day number of first working day for the mon-year
#       year   year on format YYYY
#       mon    month (1-12)
## ==========================================================================
date_get_first_working_day()
{
	LC_ALL=C cal $2 $1 | awk 'NR<3{next} {
	if(NF==1){
		next;print $1;exit
	}
	if(NF<7){
		print $1;exit
	}
	print $2;exit
}'
}

## ==========================================================================
#   Returns day number of first day for the mon-year
#       year   year on format YYYY
#       mon    month (1-12)
#       day    day to get (su mo tu we th fr sa)
#
#   example:
#       $0 2021 5 sa    will return day of a first saturday of may 2021
## ==========================================================================
date_get_first_day_of_month()
{
	case $3 in
		su) d=1 ;;
		mo) d=2 ;;
		tu) d=3 ;;
		we) d=4 ;;
		th) d=5 ;;
		fr) d=6 ;;
		sa) d=7 ;;
		*) echo unkown day; exit 1 ;;
	esac

	dates=$(LC_ALL=C cal $2 $1 |
		# skip first (textual date like February 2022)
		# and second (su mo tu we th fr sa) lines
		tail -n +3 |
		# we only need two rows of dates, kill the spare
		head -n 2 |
		# replace empty column in first week with '-'
		sed 's/   / - /g' |
		# get column coresponding to specified <day>
		awk "{print \$$d}")

	date=$(echo "$dates" | head -n 1)
	if [ x$date = x- ]; then
		# empty date, real date is in second row
		date=$(echo "$dates" | tail -n 1)
	fi

	echo $date
}

## ==========================================================================
#   Returns last day of the month
#       year   year on format YYYY
#       mon    month (1-12)
## ==========================================================================
date_get_last_day_of_month()
{
	LC_ALL=C cal $2 $1 | tr '\n' ' ' | rev | awk '{print $1}' | rev
}

# sends stdin to phone
notify_phone='sendxmpp -t -n lm-notif@kurwinet.pl'
