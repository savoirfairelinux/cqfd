#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "run cqfd with docker_build_args in config" {
    # setup -- add the command and docker_build_args option to configs
    echo "RUN cp /etc/hosts /tmp/hosts" >>"$BATS_FILE_TMPDIR/.cqfd/docker/Dockerfile"
    sed '/\[build\]/adocker_build_args="--add-host testhost:1.2.3.4"' \
        -i "$BATS_FILE_TMPDIR/.cqfdrc"
    cqfd init
    run cqfd run cat /tmp/hosts
    assert_line --regexp "1.2.3.4.*testhost"

    sed '/\[build\]/{n;d}' -i "$BATS_FILE_TMPDIR/.cqfdrc"
    sed '$d' -i "$BATS_FILE_TMPDIR/.cqfd/docker/Dockerfile"
}

