#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cqfd run should be happy using su -c" {
    # Use a custom Dockerfile with an ancient version of su.
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.orig
    echo "FROM ubuntu:16.04" >.cqfd/docker/Dockerfile
    #shellcheck disable=SC2154
    if [ "$cqfd_docker" = "podman" ]; then
        skip "This test fails when using podman"
    fi
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "su" to execute command'
}

@test "cqfd run should be happy using su --session-command" {
    # Use another custom Dockerfile with a recent version of su.
    echo "FROM ubuntu:24.04" >.cqfd/docker/Dockerfile
    if [ "$cqfd_docker" = "podman" ]; then
        skip "This test fails when using podman"
    fi
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "su" to execute session command'
}

@test "cqfd run should be happy using sudo" {
    # Install the sudo package.
    echo "ENV DEBIAN_FRONTEND=noninteractive" >>.cqfd/docker/Dockerfile
    echo "RUN apt-get update && apt-get install -y --no-install-recommends sudo" >>.cqfd/docker/Dockerfile
    if [ "$cqfd_docker" = "podman" ]; then
        # Restore initial Dockerfile.
        mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
        cqfd init
        skip "This test fails when using podman"
    fi
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "sudo" to execute command'
    # Restore initial Dockerfile.
    mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
    cqfd init
}

