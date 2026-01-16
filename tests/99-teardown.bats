#!/usr/bin/env bats

setup_file() {
    export BATS_NO_PARALLELIZE_WITHIN_FILE=true
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd images' lists the build containers" {
    run cqfd images
    assert_line --partial "cqfd_${USER}_cqfd_test"
}

@test "'cqfd prune' deletes all build containers" {
    run cqfd prune
    assert_success
}

@test "'cqfd images' should not have any build containers at this point" {
    run cqfd images
    refute_output
}

@test "'cqfd prune' on an already pruned setup should notify user" {
    run cqfd prune
    assert_line --partial "no unused images"
}
