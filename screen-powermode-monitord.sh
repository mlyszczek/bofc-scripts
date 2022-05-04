#!/bin/sh

. /usr/bofc/lib/utils.sh
cat << HELP | help ne 0 $@
Monitors power mode of monitor.
Will send mqtt event on monitor state change

needs: ddcutil program and i2c-dev module
reports only on or off events
HELP

mqtt_host=kurwik
interval=10
state_file=/var/run/screen-powermode-manitor.state
monitor_id=1
topic=/pc/$(hostname)/monitor/$monitor_id/state

while :; do
	if ddcutil -d $monitor_id getvcp d6 | grep '(sl=0x01)' >/dev/null; then
		state=on
	else
		state=off
	fi

	if [ x$state != x$(cat $state_file 2>/dev/null) ]; then
		# state change of monitor, save state and publish event
		echo $state > $state_file
		mosquitto_pub -h $mqtt_host -t $topic -m $state -q 2 -r
	fi
	
	sleep $interval
done
