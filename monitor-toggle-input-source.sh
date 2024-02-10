#!/bin/sh

. /usr/bofc/lib/utils.sh
cat << HELP | help ne 0 $@
Toggles between hdmi-1 and hdmi-2 source on my dell screen, should work
on any other screen as well, but values for source may be different
HELP

monitor_index=1

current=$(ddcutil --brief -d $monitor_index getvcp 60 | grep VCP | awk '{print $4}')
if ! test $current; then
	echo ddcutil --brief -d $monitor_index getvcp 60 returned empty value
	exit 1
fi

next=0x11
if [ $current = x11 ]; then
	next=0x12
fi

ddcutil -d 1 setvcp 60 $next
