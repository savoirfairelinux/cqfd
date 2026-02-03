#!/usr/bin/env bats

setup_file() {
    mv .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.real
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    rm .cqfd/docker/Dockerfile
    mv -f .cqfd/docker/Dockerfile.real .cqfd/docker/Dockerfile
}

@test "cqfd init fails without a Dockerfile" {
    run cqfd init
    assert_failure
}

@test "cqfd init succeeds with symlinked Dockerfile" {
    ln -s Dockerfile.real .cqfd/docker/Dockerfile
    run cqfd init
    assert_success
}
