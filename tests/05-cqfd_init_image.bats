#!/usr/bin/env bats

setup_file() {
    mv -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-image .cqfdrc
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "'cqfd init' with image and without Dockerfile succeeds" {
    run cqfd init
    assert_success
}

@test "cqfd runs pulled image from registry" {
    run cqfd
    assert_line --regexp "Ubuntu 16.04(.[[:digit:]]+)? LTS"
}
