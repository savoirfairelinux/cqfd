#!/usr/bin/env bats
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Setup so that bats tests can be run from anywhere
setup() {
    # Export to $PATH so that cqfd can be run without ./
    export PATH="$BATS_TEST_DIRNAME/../:$PATH"

}

shell-vars-setup() {
    shell_name="$1"
    shell_histfile=""

    case "$shell_name" in
    bash)
        shell_histfile="${HISTFILE:-$HOME/.${shell_name}_history}"
        ;;
    zsh)
        shell_histfile="${HISTFILE:-$HOME/.${shell_name}_history}"
        ;;
    ksh)
        shell_histfile="${HISTFILE:-$HOME/.sh_history}"
        ;;
    fish)
        shell_histfile="${fish_history:-$HOME/.local/share/fish/fish_history}"
        ;;
    esac
}

@test "can run cqfd shell script" {
    run cqfd init
    assert_success

    run cqfd
    assert_success
}
