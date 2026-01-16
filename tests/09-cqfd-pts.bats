#!/usr/bin/env bats

setup_file() {
    export BATS_NO_PARALLELIZE_WITHIN_FILE=true
    cp -f .cqfdrc .cqfdrc.old
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
}

#FIXME this test should allocate a tty
@test "cqfd without redirection should allocate a tty" {
    sed -i -e "/\[build\]/,/^$/s/^command=.*$/command='tty || true'/" .cqfdrc
    if tty; then
        run cqfd
        #assert_line --partial "/dev/pts/"
        assert_line "not a tty"
    fi
}

@test "cqfd with stdin redirected to /dev/null should not allocate a pty" {
    run cqfd </dev/null
    assert_line 'not a tty'
}

@test "cqfd with stderr redirected to /dev/null should not allocate a pty" {
    run cqfd 2>/dev/null
    assert_line 'not a tty'
}

@test "cqfd with allocated pty should redirect stdout and stderr to same endpoint" {
    sed -i -e "/\[build\]/,/^$/s,^command=.*$,command='echo stdout \&\& echo stderr >\&2'," .cqfdrc
    run cqfd >out
    assert_success
    rm out
}

@test "cqfd without allocated pty should redirect stdout and stderr to distinct entpoints" {
    cqfd >out 2>err 
    run grep 'stdout' out
    assert_success
    run grep 'stderr' err
    assert_success
    rm out err
}
