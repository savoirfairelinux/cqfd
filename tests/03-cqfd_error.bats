#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Running cqfd with an empty argument shall fail" {
    run cqfd ""
    assert_failure
}

@test "Running cqfd with an unknown argument shall fail" {
    run cqfd invalid_arg_should_fail
    assert_failure
}

@test "Running cqfd without a .cqfdrc file in the current directory shall fail" {
    empty_dir=$(mktemp -d)
    pushd "$empty_dir" >/dev/null || exit 1
    run cqfd run true
    assert_failure
    popd >/dev/null || exit 1
    # cleanup
    rm -rf "$empty_dir"
}
