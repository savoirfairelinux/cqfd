#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
    export extdir="external/dir"
    export cqfd_ext="$BATS_FILE_TMPDIR/$extdir/cqfd/cqfd"
    # First, move every local cqfd files into an external directory and use
    # alternate filenames
    mkdir -p "$extdir"
    mv .cqfd "$extdir/cqfd"
    mv .cqfdrc "$extdir/cqfdrc"
    cp -a "$PROJECT_ROOT/cqfd" "$cqfd_ext"
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    # restore local cqfd files
    mv "$extdir/cqfdrc" .cqfdrc
    mv "$extdir/cqfd" .cqfd
    rmdir -p "$extdir"
}

@test "'cqfd init' without local files should fail" {
    run "$cqfd_ext" init
    assert_failure
}

@test "cqfd init using alternate filenames in an external directory using filenames should work" {
    run "$cqfd_ext" -C "$extdir" -d cqfd -f cqfdrc init
    assert_success
}

@test "cqfd init using alternate filenames in an external directory using relative filenames should work" {
    run "$cqfd_ext" -d "$extdir/cqfd" -f "$extdir/cqfdrc" init
    assert_success
}

@test "cqfd init using alternate filenames in an external directory using absolute filenames should work" {
    run "$cqfd_ext" -d "$PWD/$extdir/cqfd" -f "$PWD/$extdir/cqfdrc" init
    assert_success
}
