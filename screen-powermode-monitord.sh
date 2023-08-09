#!/bin/sh

. /usr/bofc/lib/utils.sh
cat << HELP | help gt 1 $@
Monitors power mode of monitor.
Will send mqtt event on monitor state change

--off        this will one time send "off" event, usefull before going to sleep

needs: ddcutil program and i2c-dev module
reports only on or off events
HELP

mqtt_host=kurwik
interval=10
state_file=/var/run/screen-powermode-manitor.state
monitor_id=1
topic=/pc/$(hostname)/monitor/$monitor_id/state

if [ x$1 = x--off ]; then
	echo force-off > $state_file
	mosquitto_pub -h $mqtt_host -t $topic -m off -q 2 -r
	exit 0
fi

echo -n > $state_file
while :; do
	ddout=$(ddcutil -d $monitor_id getvcp d6 2>/dev/null)

	if echo $ddout | grep '(sl=0x01)' >/dev/null; then
		state=on
	else
		state=off
	fi

	if [ x$state != x$(cat $state_file 2>/dev/null) ]; then
		if [ x$(cat $state_file 2>/dev/null) == xforce-off ]; then
			# prevent race condition in case we force-off state,
			# in this case screen was forced to be "off" (even if
			# it is not off) most likely before pc is going to sleep.
			# In that case we don't send state, just rewrite state
			# from force-off to off, so next time we loop, we
			# continue as normal
			echo off > $state_file
			sleep $interval
			continue
		fi
		# state change of monitor, save state and publish event
		echo $state > $state_file
		mosquitto_pub -h $mqtt_host -t $topic -m $state -q 2 -r
	fi
	
	sleep $interval
done
