#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "cqfd run fails when the Docker image lacks required commands" {
    bats_require_minimum_version 1.5.0
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.orig
    cp -f .cqfd/docker/Dockerfile.missing_dependencies .cqfd/docker/Dockerfile
    run cqfd init
    assert_success
    #shellcheck disable=SC2154
    if [ "$cqfd_docker" != "podman" ]; then
        run cqfd run
    else
        run -127 cqfd run
    fi
    assert_failure
}


@test "cqfd run with satisfied command requirements, using su" {
    echo 'RUN apk add bash shadow' >>.cqfd/docker/Dockerfile

    if [ "$cqfd_docker" = "podman" ]; then
        skip "This test fails when using podman"
    fi
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "su"'
}

@test "cqfd run with satisfied command requirements, using sudo" {
    echo 'RUN apk add sudo' >>.cqfd/docker/Dockerfile
    if [ "$cqfd_docker" = "podman" ]; then
        mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
        cqfd init
        skip "This test fails when using podman"
    fi
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "sudo"'
    mv -f .cqfd/docker/Dockerfile.orig .cqfd/docker/Dockerfile
    cqfd init
}
