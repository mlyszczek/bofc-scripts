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

# sends stdin to phone
notify_phone='sendxmpp -t -n lm-notif@kurwinet.pl'
