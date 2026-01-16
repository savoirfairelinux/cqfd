#!/usr/bin/env bash

_common_setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
}

_common_setup_file() {
    mkdir -p "$BATS_FILE_TMPDIR/.cqfd/docker"
    cp -a "$PROJECT_ROOT"/tests/test_data/. "$BATS_FILE_TMPDIR/."
    cd "$BATS_FILE_TMPDIR/" || exit 1
    cp -f cqfdrc-test .cqfdrc
}
