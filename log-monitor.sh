#!/bin/zsh

. /usr/bofc/lib/utils.sh
cat << HELP | help ne 2 $@
usage: $0 <file> <regexp>

Monitors <file> for <regexp> and sends email to root for each line that matches
<regexp> is perl regex, as in command run is "grep -P"
HELP

tail -f "$1" | grep -P "$2" --line-buffered |
while read -r line; do
	printf "Subject: [log-monitor] $1: $2\n\n%s\n" "$line" | sendmail root
done
