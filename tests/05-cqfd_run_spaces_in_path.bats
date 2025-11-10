#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "Working from a sub-directory with spaces should also work." {
    # Create one and copy the necessary config inside it.
    spaces_dir="aa bb cc dd"
    spaces_dir2="aa2 bb2 cc2 dd2"
    mkdir -p "$spaces_dir"/"$spaces_dir2"
    cp -a .cqfd .cqfdrc "$spaces_dir"/"$spaces_dir2"
    pushd "$spaces_dir"/"$spaces_dir2" >/dev/null || exit 1
    file="rand.$RANDOM"
    cqfd run touch "$file"
    run test -f "$file" 
    assert_success
    rm -f "$file"

    # Teardown
    popd >/dev/null || exit 1
    rm -rf "$spaces_dir"
}
