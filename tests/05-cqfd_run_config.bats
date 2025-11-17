#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    confdir=$BATS_SUITE_TMPDIR/.config/dir
    flavor="foo"
}

@test "cqfd run with config in $confdir/mycqfdrc" {
    # cp the default conf and replace the original with a fake one
    mkdir -p "$confdir"
    mv .cqfdrc "$confdir"/mycqfdrc
    test_file="a/cqfd_a.txt"
    run cqfd -f "$confdir"/mycqfdrc run
    assert_success
    run test -f "$test_file"
    assert_success
    rm -f "$test_file"
}

@test "cqfd run and override with additionnal cmd" {
    test_file="file.$RANDOM"
    run cqfd -f "$confdir"/mycqfdrc run touch "$test_file"
    assert_success
    run test -f "$test_file"
    assert_success
    rm -f "$test_file"
}

@test "cqfd run and build a given '$flavor' flavor" {
    test_file="$flavor.$RANDOM"
    run cqfd -f "$confdir"/mycqfdrc -b "$flavor" run touch "$test_file"
    assert_success
    run test -f "$test_file"
    assert_success
    rm -f "$test_file"
}

@test "cqfd run and build a given '$flavor' flavor (inverted args)" {
    test_file="$flavor.$RANDOM"
    run cqfd -b "$flavor" -f "$confdir"/mycqfdrc run touch "$test_file"
    assert_success
    run test -f "$test_file"
    assert_success
    rm -f "$test_file"
    # restore for further tests
    mv -f "$confdir"/mycqfdrc .cqfdrc
}
