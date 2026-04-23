#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' forwards user git config to container when ~/.gitconfig exists" {
    if [ ! -f "$HOME/.gitconfig" ]; then
        skip "$HOME/.gitconfig does not exist on this system"
    fi

    host_stat=$(stat -c '%d:%i' "$HOME/.gitconfig")

    run cqfd run "stat -c '%d:%i' \$HOME/.gitconfig"
    assert_success
    assert_line "$host_stat"
}

@test "'cqfd run' disables user git config forwarding with CQFD_NO_USER_GIT_CONFIG=true" {
    if [ ! -f "$HOME/.gitconfig" ]; then
        skip "$HOME/.gitconfig does not exist on this system"
    fi

    host_stat=$(stat -c '%d:%i' "$HOME/.gitconfig")

    CQFD_NO_USER_GIT_CONFIG=true \
        run cqfd run "if [ -e \$HOME/.gitconfig ]; then test \"\$(stat -c '%d:%i' \$HOME/.gitconfig)\" != '$host_stat'; fi"
    assert_success
}
