#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.init_extra_env .cqfd/docker/Dockerfile
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    # restore initial Dockerfile
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "'cqfd init' without CQFD_EXTRA_BUILD_ARGS should fail" {
    run cqfd init
    assert_failure
}

@test "'cqfd init' with CQFD_EXTRA_BUILD_ARGS should succeed" {
    export CQFD_EXTRA_BUILD_ARGS="--build-arg FOO=foo --no-cache"
    run cqfd init
    assert_success
}
