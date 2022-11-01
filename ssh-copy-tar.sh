#!/bin/sh

. /usr/bofc/lib/utils.sh
cat << HELP | help ne 2 $@
usage: $0 <src> <dst>

Copies <src> dir to <dst>. Syntax is like with scp, for example

$0 carrot:/etc/portage hex:/etc
$0 /etc/portage hex:/etc
$0 hex:/etc/portage /etc

If host is ommited, dir is treated as local directory. If you have ':' in
dir name, you're fucked, I didn't implement it:)
HELP

set -e

src_host=$(echo "$1" | cut -s -f1 -d:)
if [ $src_host ]; then
	src_dir=$(echo "$1" | cut -f2 -d:)
else
	src_dir=$1
fi

dst_host=$(echo "$2" | cut -s -f1 -d:)
if [ $dst_host ]; then
	dst_dir=$(echo "$2" | cut -f2 -d:)
else
	dst_dir=$2
fi

dst_dir+=/$(basename $src_dir)
echo ":: calculating size"
if [ "$src_host" ]; then
	size=$(ssh $src_host "du -sb $src_dir" | awk '{print $1}')
else
	size=$(du -sb $src_dir | awk '{print $1}')
fi

src="tar -C $src_dir -cf - . | pv -cN tar -s$size | lz4 | pv -cN lz4"
if [ "$src_host" ]; then
	src="ssh $src_host '$src'"
fi

dst="lz4 -d | tar -C $dst_dir -xpf -"
if [ "$dst_host" ]; then
	dst="ssh $dst_host '$dst'"
	ssh $dst_host "mkdir -p $dst_dir"
else
	mkdir -p $dst_dir
fi

echo "$src | $dst"
eval "$src | $dst"
