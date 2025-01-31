#!/usr/bin/env -S cqfd shell
if ! test -e /.dockerenv; then
	exit 1
fi
source /etc/os-release
echo "$PRETTY_NAME"
