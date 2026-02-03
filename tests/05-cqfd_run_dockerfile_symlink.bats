#!/usr/bin/env bats

setup_file() {
    mkdir -p .cqfd-symlink/docker
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    rm -r .cqfd-symlink
}

@test "cqfd init fails without a Dockerfile" {
    run cqfd -d .cqfd-symlink init
    assert_failure
}

@test "cqfd init succeeds with symlinked Dockerfile" {
    ln -s ../../.cqfd/docker/Dockerfile .cqfd-symlink/docker/Dockerfile
    run cqfd -d .cqfd-symlink init
    assert_success
}
