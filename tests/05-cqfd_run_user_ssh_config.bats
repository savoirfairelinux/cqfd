#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
}

@test "'cqfd run' forwards user SSH config to container when ~/.ssh exists" {
    if [ ! -d "$HOME/.ssh" ]; then
        skip "$HOME/.ssh does not exist on this system"
    fi

    host_stat=$(stat -c '%d:%i' "$HOME/.ssh")

    run cqfd run "stat -c '%d:%i' \$HOME/.ssh"
    assert_success
    assert_line "$host_stat"
}

@test "'cqfd run' disables user SSH config forwarding with CQFD_NO_USER_SSH_CONFIG=true" {
    if [ ! -d "$HOME/.ssh" ]; then
        skip "$HOME/.ssh does not exist on this system"
    fi

    host_stat=$(stat -c '%d:%i' "$HOME/.ssh")

    CQFD_NO_USER_SSH_CONFIG=true \
        run cqfd run "if [ -e \$HOME/.ssh ]; then test \"\$(stat -c '%d:%i' \$HOME/.ssh)\" != '$host_stat'; fi"
    assert_success
}
