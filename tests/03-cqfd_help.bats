#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd help' shall be an accepted command" {
    run cqfd help
    assert_success
}

@test "'cqfd help' shall produce a useful help message" {
    run cqfd help
    for word in Usage Options Commands; do
        assert_line --partial "$word"
    done
}
