#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-platform .cqfdrc
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.platform .cqfd/docker/Dockerfile
}

teardown() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
    cqfd init
}

@test "cqfd run docker using multi-platform" {
    run cqfd init
    assert_success
    run cqfd
    assert_line --regexp 'aarch64'
}

