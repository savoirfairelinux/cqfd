#!/usr/bin/env -S cqfd -b pkg shell
set -e
makepkg --force --skipchecksums "$@"
shellcheck --shell=bash --exclude=SC2034,SC2154,SC2164 PKGBUILD
namcap PKGBUILD* *.pkg.tar*
