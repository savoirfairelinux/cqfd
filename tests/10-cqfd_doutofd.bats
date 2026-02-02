#!/usr/bin/env bats

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

@test "cqfd is not able to run docker using host docker daemon by default" {
    #shellcheck disable=SC2154
    if [ "$cqfd_docker" = "docker" ] && getent group docker | grep -q "$USER"; then
        cp -f .cqfd/docker/Dockerfile.doutofd .cqfd/docker/Dockerfile
        sed -i -e "/\[build\]/,/^$/s,^command=.*$,command='docker run --rm -t ubuntu:24.04 cat /etc/os-release'," .cqfdrc

        run cqfd init
        assert_success
        run cqfd
        assert_failure
    fi
}

@test "cqfd run docker using host docker daemon when option is passed in environment" {
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

@test "cqfd run docker using host docker daemon when option is passed in .cqfdrc" {
    #shellcheck disable=SC2154
    if [ "$cqfd_docker" = "docker" ] && getent group docker | grep -q "$USER"; then
        cp -f .cqfd/docker/Dockerfile.doutofd .cqfd/docker/Dockerfile
        sed -i -e "/\[build\]/,/^$/s,^command=.*$,command='docker run --rm -t ubuntu:24.04 cat /etc/os-release'\nbind_docker_sock='true'," .cqfdrc

        run cqfd init
        assert_success
        run cqfd
        assert_line --regexp 'PRETTY_NAME="Ubuntu 24.04(.[[:digit:]]+)? LTS"'
    fi
}

