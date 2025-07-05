#!/usr/bin/env -S cqfd -b pkg shell
makepkg --force --skipchecksums "$@"
namcap PKGBUILD* *.pkg.tar*
