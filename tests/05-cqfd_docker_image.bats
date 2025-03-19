#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cqfd_docker="${CQFD_DOCKER:-docker}"
    mv -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-docker_run_image .cqfdrc
}

teardown() {
    # Restore initial .cqfdrc and Dockerfile
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "'cqfd' pulls image" {
    docker_run_image="ubuntu:16.04"
    sed -i -e "s!^docker_run_image=.*\$!docker_run_image='$docker_run_image'!" .cqfdrc
    if "$cqfd_docker" inspect "$docker_run_image"; then
        "$cqfd_docker" rmi "$docker_run_image"
    fi

    run cqfd init
    assert_success
    run "$cqfd_docker" inspect "$docker_run_image"
    assert_failure

    run cqfd
    assert_success
    assert_line --regexp "Ubuntu 16.04(.[[:digit:]]+)? LTS"
    run "$cqfd_docker" inspect "$docker_run_image"
    assert_success
}
