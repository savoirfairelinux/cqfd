#!/usr/bin/env bash

setup_suite() {
    export cqfd_docker="${CQFD_DOCKER:-docker}"
    mkdir -p "$BATS_SUITE_TMPDIR/.cqfd/docker"
    PROJECT_ROOT="$( cd "$BATS_CWD/.." && pwd )"
    export PROJECT_ROOT
    export PATH="$BATS_SUITE_TMPDIR/.cqfd:$PATH"
    cp -a "$PROJECT_ROOT"/cqfd "$BATS_SUITE_TMPDIR/.cqfd/"
    cp -a "$PROJECT_ROOT"/tests/test_data/. "$BATS_SUITE_TMPDIR/."
    cd "$BATS_SUITE_TMPDIR/" || exit 1
    cp -f cqfdrc-test .cqfdrc
}
