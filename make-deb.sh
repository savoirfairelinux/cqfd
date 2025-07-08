#!/usr/bin/env -S "CQFD_EXTRA_RUN_ARGS=--volume ${HOME}:${HOME}" cqfd -b deb shell
set -e
dpkg-buildpackage -us -uc "$@"
cp ../cqfd_*.deb \
   ../cqfd_*.buildinfo \
   ../cqfd_*.changes \
   ../cqfd_*.dsc \
   ../cqfd_*.tar.gz \
   .
lintian *.deb
