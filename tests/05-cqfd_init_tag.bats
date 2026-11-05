#!/usr/bin/env bats

setup_file() {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-tag .cqfdrc
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "'cqfd init' with tag builds templated image" {
    random="$RANDOM$RANDOM"
    tag="cqfd-%Un-%Po-%Pn-%Dh-%Bd-$random"
    sed -i -e "s!^tag=.*\$!tag='$tag'!" .cqfdrc
    # shellcheck disable=SC2001
    un="$(sed 's/[^0-9a-zA-Z\-]/_/g' <<<"$USER")"
    dh="$(sha256sum .cqfd/docker/Dockerfile | cut -b 1-7)"
    image="cqfd-$un-cqfd-tag_test-$dh-docker-$random"
    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$image"; then
        "$cqfd_docker" rmi "$image"
    fi

    run cqfd init
    assert_success

    run "$cqfd_docker" inspect "$image"
    assert_success

    "$cqfd_docker" rmi "$image"
}

@test "'cqfd init' with tag and distro build templated image" {
    random="$RANDOM$RANDOM"
    tag="cqfd-%Un-%Po-%Pn-%DH-%Bd-$random"
    sed -i -e "s!^tag=.*\$!tag='$tag'!" .cqfdrc
    # shellcheck disable=SC2001
    un="$(sed 's/[^0-9a-zA-Z\-]/_/g' <<<"$USER")"
    dh="$(sha256sum .cqfd/fedora/Dockerfile | cut -b 1-64)"
    image="cqfd-$un-cqfd-tag_test-$dh-fedora-$random"
    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$image"; then
        "$cqfd_docker" rmi "$image"
    fi

    sed -i -e "s/\[build\]/[build]\ndistro='fedora'/" .cqfdrc
    run cqfd init
    assert_success

    run "$cqfd_docker" inspect "$image"
    assert_success

    "$cqfd_docker" rmi "$image"
}
