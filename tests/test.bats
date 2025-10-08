#!/usr/bin/env bats
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Setup so that bats tests can be run from anywhere
setup() {
    # Export to $PATH so that cqfd can be run without ./
    export PATH="$BATS_TEST_DIRNAME/../:$PATH"
}

@test "can run cqfd shell script" {
    run cqfd init
    assert_success

    run cqfd
    assert_success
}
