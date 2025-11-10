#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd init' without context should fail the context" {
    cqfd init
    run cqfd run "! test -e /tmp/cqfdrc-build_context"
    assert_success
}

@test "'cqfd init' with context changes the context" {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.orig
    cp -f .cqfd/docker/Dockerfile.build_context .cqfd/docker/Dockerfile
    cp -f cqfdrc-build_context .cqfdrc
    run cqfd init
    assert_success
    run cqfd run "test -e /tmp/cqfdrc-build_context"
    assert_success
    cp -f cqfdrc-test .cqfdrc
    mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
}
