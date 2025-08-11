#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cqfd_docker="${CQFD_DOCKER:-docker}"
}

@test "cqfd pulls image custom_img_name from registry" {
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
    cp -f .cqfd/docker/Dockerfile.init_custom_image .cqfd/docker/Dockerfile
    cp -f .cqfdrc .cqfdrc.old
    cp -f cqfdrc-custom_image .cqfdrc

    custom_img_name="ubuntu:16.04"
    sed -i -e "s!^custom_img_name=.*\$!custom_img_name='$custom_img_name'!" .cqfdrc
    if "$cqfd_docker" inspect "$custom_img_name"; then
        "$cqfd_docker" rmi "$custom_img_name"
    fi

    run cqfd
    assert_success
    assert_line --regexp "Ubuntu 16.04(.[[:digit:]]+)? LTS"
}

@test "'cqfd init' creates custom_img_name" {
    custom_img_name="cqfd_test_custom_image_$RANDOM$RANDOM"
    sed -i -e "s!^custom_img_name=.*\$!custom_img_name='$custom_img_name'!" .cqfdrc
    if "$cqfd_docker" inspect "$custom_img_name"; then
        "$cqfd_docker" rmi "$custom_img_name"
    fi

    # cqfd fails pulling inexistant image $custom_img_name from registry"
    run cqfd
    assert_failure

    # cqfd init creates custom_img_name from Dockerfile
    run cqfd init
    assert_success
    run "$cqfd_docker" inspect "$custom_img_name"
    assert_success

    # cqfd runs created image $custom_img_name
    run cqfd
    assert_success
    assert_line --regexp "Ubuntu 24.04(.[[:digit:]]+)? LTS"

    # cleanup
    "$cqfd_docker" rmi "$custom_img_name"
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}
