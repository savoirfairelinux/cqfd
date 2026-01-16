#!/usr/bin/env bats

setup_file() {
    load 'test_helper/common-setup'
    _common_setup_file
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
    cp -f .cqfdrc .cqfdrc.old
    cp -f .cqfd/docker/Dockerfile .cqfd/docker/Dockerfile.old
}

teardown() {
    mv -f .cqfdrc.old .cqfdrc
    mv -f .cqfd/docker/Dockerfile.old .cqfd/docker/Dockerfile
}

@test "cqfd run docker using host docker daemon" {
    #shellcheck disable=SC2154
    if [ "$cqfd_docker" = "docker" ] && getent group docker | grep -q "$USER"; then
        cp -f .cqfd/docker/Dockerfile.doutofd .cqfd/docker/Dockerfile
        sed -i -e "/\[build\]/,/^$/s,^command=.*$,command='docker run --rm -t ubuntu:24.04 cat /etc/os-release'," .cqfdrc

        run cqfd init
        assert_success
        CQFD_BIND_DOCKER_SOCK=true run cqfd
        assert_line --regexp 'PRETTY_NAME="Ubuntu 24.04(.[[:digit:]]+)? LTS"'
    fi
}
