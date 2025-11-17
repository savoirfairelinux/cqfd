#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cqfd_docker="${CQFD_DOCKER:-docker}"
}

@test "'cqfd run' should add extra_groups provided by an environment variable" {
    cp -f .cqfdrc .cqfdrc.old
    if [ "$cqfd_docker" = "podman" ]; then
        skip "This test fails when using podman"
    fi
    user_extra_groups="docker newgroup:12345" run cqfd run groups
    assert_line --regexp "docker.*newgroup"
}

@test "'cqfd run' should add extra_groups provided by the config" {
    if [ "$cqfd_docker" = "podman" ]; then
        mv -f .cqfdrc.old .cqfdrc
        skip "This test fails when using podman"
    fi
    echo 'user_extra_groups="docker newgroup:12345"' >>.cqfdrc
    run cqfd run groups
    assert_line --regexp "docker.*newgroup"
    mv -f .cqfdrc.old .cqfdrc
}
