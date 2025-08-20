#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cp -f .cqfdrc .cqfdrc.orig
    cp -f cqfdrc-multi_platform .cqfdrc
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.orig
    cp -f .cqfd/docker/Dockerfile.multi_platform .cqfd/docker/Dockerfile

    native_machine=x86_64
    cross_machine=aarch64
    native_platform=linux/amd64
    cross_platform=linux/arm64
    if uname -m | grep -q aarch64; then
        native_machine=aarch64
        cross_machine=x86_64
        native_platform=linux/arm64
        cross_platform=linux/amd64
    fi
}

teardown() {
    mv -f .cqfdrc.orig .cqfdrc
    mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
}

@test "cqfd run native docker platform without environment CQFD_PLATFORM or option --platform" {
    run cqfd init
    assert_success
    run cqfd
    assert_line --regexp "$native_machine"
}

@test "cqfd run native docker platform with environment CQFD_PLATFORM" {
    CQFD_PLATFORM="$native_platform" run cqfd init
    assert_success
    CQFD_PLATFORM="$native_platform" run cqfd
    assert_line --regexp "$native_machine"
}

@test "cqfd run native docker platform with option --platform" {
    run cqfd --platform "$native_platform" init
    assert_success
    run cqfd --platform "$native_platform"
    assert_line --regexp "$native_machine"
}

@test "cqfd run cross docker platform with environment CQFD_PLATFORM" {
    CQFD_PLATFORM="$cross_platform" run cqfd init
    assert_success
    CQFD_PLATFORM="$cross_platform" run cqfd
    assert_line --regexp "$cross_machine"
}

@test "cqfd run cross docker platform with option --platform" {
    run cqfd --platform "$cross_platform" init
    assert_success
    run cqfd --platform "$cross_platform"
    assert_line --regexp "$cross_machine"
}

@test "Test cross platform helper scripts (linux/amd64, linux/aarch64)" {
    ln -s cqfd "$BATS_SUITE_TMPDIR/.cqfd/linux-amd64-cqfd"
    ln -s cqfd "$BATS_SUITE_TMPDIR/.cqfd/linux-arm64-cqfd"
    run bash linux-amd64-cqfd
    assert_line --regexp "x86_64"
    run bash linux-arm64-cqfd
    assert_line --regexp "aarch64"
    rm -f "$BATS_SUITE_TMPDIR/.cqfd/linux-amd64-cqfd"
    rm -f "$BATS_SUITE_TMPDIR/.cqfd/linux-arm64-cqfd"
}
