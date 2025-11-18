#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

setup_file() {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.home_path .cqfd/docker/Dockerfile
}

teardown_file() {
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "cqfd run deletes the ubuntu user if it exists" {
    #shellcheck disable=SC2154
    if [ "$cqfd_docker" = "podman" ]; then
        skip "podman maps current user to root in the container, so there is no conflict with ubuntu user"
    fi
    run cqfd init
    assert_success
    run cqfd exec grep ubuntu:x:1000:1000 /etc/passwd
    assert_failure
}

@test "cqfd user has access to ssh config in home directory when ubuntu user existed" {
    run cqfd init
    assert_success
    run cqfd run 'ssh -G random_host | grep userknownhostsfile'
    assert_line --partial "$HOME"
}

@test "cqfd user has access to ssh config in home directory when no 1000 user existed" {
    sed -i "s/ubuntu:24.04/debian:trixie/" .cqfd/docker/Dockerfile
    run cqfd init
    assert_success
    run cqfd run 'ssh -G random_host | grep userknownhostsfile'
    assert_line --partial "$HOME"
}
