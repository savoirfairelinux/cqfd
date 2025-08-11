#!/usr/bin/env bats

setup_file() {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.init_custom_image .cqfd/docker/Dockerfile
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-custom_image .cqfdrc
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "cqfd pulls custom image from registry" {
    custom_img_name="ubuntu:16.04"

    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$custom_img_name"; then
        "$cqfd_docker" rmi "$custom_img_name"
    fi

    run cqfd
    assert_line --regexp "Ubuntu 16.04(.[[:digit:]]+)? LTS"
}

@test "cqfd fails pulling inexistant custom image from registry" {
    custom_img_name="cqfd_test_custom_image_$RANDOM$RANDOM"
    sed -i -e "s!^custom_img_name=.*\$!custom_img_name='$custom_img_name'!" .cqfdrc

    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$custom_img_name"; then
        "$cqfd_docker" rmi "$custom_img_name"
    fi

    run cqfd
    assert_failure

    run "$cqfd_docker" inspect "$custom_img_name"
    assert_failure
}

@test "cqfd init creates custom image" {
    # shellcheck disable=SC2030
    custom_img_name="cqfd_test_custom_image_$RANDOM$RANDOM"
    sed -i -e "s!^custom_img_name=.*\$!custom_img_name='$custom_img_name'!" .cqfdrc

    # shellcheck disable=SC2154
    if "$cqfd_docker" inspect "$custom_img_name"; then
        "$cqfd_docker" rmi "$custom_img_name"
    fi

    run cqfd init
    assert_success

    "$cqfd_docker" inspect "$custom_img_name"

    echo "custom_img_name=$custom_img_name" >.cqfd/docker/custom_img_name
}

@test "cqfd runs created custom image" {
    # shellcheck disable=SC1091
    source .cqfd/docker/custom_img_name

    run cqfd
    assert_line --regexp "Ubuntu 24.04(.[[:digit:]]+)? LTS"

    # shellcheck disable=SC2031
    "$cqfd_docker" rmi "$custom_img_name"
    rm .cqfd/docker/custom_img_name
}
