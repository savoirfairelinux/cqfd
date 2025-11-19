#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd deinit' with a proper .cqfdrc should pass" {
    run cqfd deinit
    assert_success
}

@test "'cqfd deinit' with a nonexistent Dockerfile should fail" {
    cp -f .cqfdrc .cqfdrc.old
    sed -i -e "s/\[build\]/[build]\ndistro='thisshouldfail'/" .cqfdrc
    run cqfd deinit
    assert_failure
}

@test "'cqfd deinit' with a proper Dockerfile should fail" {
    sed -i -e "s/thisshouldfail/centos/" .cqfdrc
    run cqfd init
    assert_success
    run cqfd deinit
    assert_success
    # restore cqfdrc
    mv -f .cqfdrc.old .cqfdrc
}

@test "'cqfd deinit' with an already deinit'ed image should fail" {
    run cqfd deinit
    assert_failure
}

@test "'cqfd deinit' with CQFD_EXTRA_RMI_ARGS should succeed" {
    CQFD_EXTRA_RMI_ARGS="--force" run cqfd deinit
    assert_success
}
