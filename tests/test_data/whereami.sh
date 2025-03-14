#!/usr/bin/env -S cqfd shell
if ! [ -e /.dockerenv ] && ! [ -e /run/.containerenv ]; then
	exit 1
fi
source /etc/os-release
echo "$PRETTY_NAME"
