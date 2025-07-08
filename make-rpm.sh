#!/usr/bin/env -S "CQFD_EXTRA_RUN_ARGS=--volume ${PWD}/rpmbuild:${HOME}/rpmbuild --volume ${PWD}/cqfd.spec:${HOME}/rpmbuild/SPECS/cqfd.spec" cqfd -b rpm shell
set -e
rpmdev-setuptree
cd ~/rpmbuild/SPECS
rpmbuild --undefine=_disable_source_fetch --undefine=dist -ba cqfd.spec "$@"
cp ~/rpmbuild/SRPMS/*.src.rpm ~/rpmbuild/RPMS/*/*.rpm "$OLDPWD"
rpmlint *.rpm
