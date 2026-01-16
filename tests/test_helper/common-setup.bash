#!/usr/bin/env bash

_common_setup_file() {
    cd "$BATS_FILE_TMPDIR/" || exit 1
    cp -a "$PROJECT_ROOT"/tests/test_data/. .
    cp -f cqfdrc-test .cqfdrc
}

_common_setup() {
    load 'test_helper/bats-support/load'
    load 'test_helper/bats-assert/load'
}
