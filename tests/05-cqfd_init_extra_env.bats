#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd init' without CQFD_EXTRA_BUILD_ARGS should fail" {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.orig
    cp -f .cqfd/docker/Dockerfile.init_extra_env .cqfd/docker/Dockerfile

    run cqfd init
    assert_failure
}

@test "'cqfd init' with CQFD_EXTRA_BUILD_ARGS should succeed" {
    export CQFD_EXTRA_BUILD_ARGS="--build-arg FOO=foo --no-cache"
    run cqfd init
    assert_success
    # restore initial Dockerfile
    mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
}
