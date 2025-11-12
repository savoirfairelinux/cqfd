#!/usr/bin/env bats

setup_file() {
    export extdir="external/dir"
    export cqfd_ext="$BATS_SUITE_TMPDIR/$extdir/.cqfd/cqfd"
    # First, move every local cqfd files into an external directory and use
    # alternate filenames
    mkdir -p "$extdir"
    mv .cqfd "$extdir/.cqfd"
    mv .cqfdrc "$extdir/.cqfdrc"
    cd "$extdir" || exit 1
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    # restore local cqfd files
    cd "$BATS_SUITE_TMPDIR" || exit 1
    mv "$extdir/.cqfdrc" .cqfdrc
    mv "$extdir/.cqfd" .cqfd
    rmdir -p "$extdir"
}

@test "cqfd run using default working directory should work" {
    run "$cqfd_ext" run "stat -c '%u' ."
    assert_success
    assert_line "$UID"
    run "$cqfd_ext" run "stat -c '%u' .."
    assert_success
    assert_line "0"
}

@test "'cqfd run' using alternate working directory should work" {
    run $cqfd_ext -C "../.." -d "$extdir/.cqfd" run "stat -c '%u' ."
    assert_success
    assert_line "$UID"
    run "$cqfd_ext" -C "../.." -d "$extdir/.cqfd" run "stat -c '%u' .."
    assert_success
    assert_line "0"
}
