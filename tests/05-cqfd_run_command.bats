#!/usr/bin/env bats

setup_file() {
    export BATS_NO_PARALLELIZE_WITHIN_FILE=true
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
    test_file="test.test_run_commands"
    if [ -f "$test_file" ]; then
        rm -f "$test_file"
    fi
}

teardown() {
    rm -f "$test_file"
}

@test "cqfd run \"touch somefile\" creates the file" {
    run cqfd run "touch $test_file"
    assert_success
    run test -f "$test_file"
    assert_success
}

@test "cqfd run touch somefile (no quotes) creates the file" {
    run cqfd run touch "$test_file"
    assert_success
    run test -f "$test_file"
    assert_success
}

@test "cqfd run with additional argument, do not preserve the arguments" {
    # shellcheck disable=SC2016
    run cqfd run /bin/sh -c 'printf "0=$0,*=$*,#=$#"' zero one two three
    assert_line --regexp "0=(\/bin\/)?sh,\*=,#=0"
}
