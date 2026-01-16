#!/usr/bin/env bash

setup_suite() {
    export cqfd_docker="${CQFD_DOCKER:-docker}"
    mkdir -p "$BATS_SUITE_TMPDIR/.cqfd/docker"
    # get the containing directory of this file
    # use $BATS_TEST_FILENAME instead of ${BASH_SOURCE[0]} or $0,
    # as those will point to the bats executable's location or the preprocessed file respectively
    PROJECT_ROOT="$( cd "$( dirname "$BATS_TEST_FILENAME" )/.." >/dev/null 2>&1 && pwd )"
    export PROJECT_ROOT
    # make executables in src/ visible to PATH
    export PATH="$PROJECT_ROOT:$PATH"
    cp -a "$PROJECT_ROOT"/tests/test_data/. "$BATS_SUITE_TMPDIR/."
    cd "$BATS_SUITE_TMPDIR/" || exit 1
    cp -f cqfdrc-test .cqfdrc
}
