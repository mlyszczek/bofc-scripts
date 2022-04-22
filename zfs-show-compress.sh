#!/bin/sh

. /usr/bofc/lib/utils.sh
cat << HELP | help eq 0 $@
usage: $0 <file> [files...]

Shows compression ratio for a file(s)
HELP


for i in $* ; do
	actualsize=`du -sh --apparent-size $i |awk '{print $1}'`
	compressedsize=`du -sh $i |awk '{print $1}'`

	printf "%6s => %6s    $i\n" "$actualsize" "$compressedsize"
done
