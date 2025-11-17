#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

setup_file() {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.missing_dependencies .cqfd/docker/Dockerfile
}

teardown_file() {
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "cqfd run fails when the Docker image lacks required commands" {
    bats_require_minimum_version 1.5.0
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
        skip "This test fails when using podman"
    fi
    run cqfd init
    assert_success
    run cqfd --verbose run true
    assert_line --partial 'Using "sudo"'
}
