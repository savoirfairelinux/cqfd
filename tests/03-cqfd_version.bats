#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd version' shall be an accepted command" {
    run cqfd version
    assert_success
}

@test "'cqfd version' shall produce a version message" {
    run cqfd version
    assert_line --regexp "^[0-9.]+(-[a-z]+)?\$"
}
