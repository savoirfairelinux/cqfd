#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cqfd exec with no argument should fail" {
    run cqfd exec
    assert_failure
}

@test "cqfd exec with argument should succeed" {
    run cqfd exec true
    assert_success
}

@test "cqfd exec should return same status" {
    run cqfd exec exit 10
    assert_failure 10
}

@test "cqfd exec should preserve the arguments" {
    # shellcheck disable=SC2016
    run cqfd exec /bin/sh -c 'printf "0=$0,*=$*,#=$#"' zero one two three
    assert_line "0=zero,*=one two three,#=3"
}
