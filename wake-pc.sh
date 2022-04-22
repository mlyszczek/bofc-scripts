#!/bin/sh

. /usr/bofc/lib/utils.sh
cat << HELP | help ne 1 $@
usage: $0 <hostname>

wakes <hostname> over wake on lan
hostname can be: hex
HELP

hex=d8:bb:c1:3d:30:93

wakeonlan ${!1}
