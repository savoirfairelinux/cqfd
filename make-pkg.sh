#!/usr/bin/env -S cqfd -b pkg shell
makepkg --skipchecksums --force "$@"
namcap PKGBUILD* *.pkg.tar*
