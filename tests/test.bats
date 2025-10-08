#!/usr/bin/env bats
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Setup so that bats tests can be run from anywhere
setup() {
    # Export to $PATH so that cqfd can be run without ./
    export PATH="$BATS_TEST_DIRNAME/../:$PATH"

    posix_cmds_file="$BATS_TEST_DIRNAME/posix_shell_cmds.txt"
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

run-posix-commands() {
    shell_name="$1"
    rm_histfile="$2"
    command_to_run="hello from the other sideee $shell_name"

    if [ -n "$rm_histfile" ] && [ -f "$shell_histfile" ]; then
        mv "$shell_histfile" "$shell_histfile.old"
        rm -f "$shell_histfile"
    fi

    # add line to test the commands file
    echo "echo $command_to_run" >> "$posix_cmds_file"
    run ./cqfd "$shell_name" -i < "$posix_cmds_file"

    # test that the shell commands have been run from the commands file
    assert_line --partial "$command_to_run"

    # test that the commands run are now in the $shell_histfile
    if [ -f "$shell_histfile" ]; then
        run tail "$shell_histfile"
        assert_line --partial "$command_to_run"

        # remove the command from the history file for future tests if so
        sed -i "/$command_to_run/d" "$posix_cmds_file"
    else
        assert_failure "shell history file not set"
    fi
    # restore old history file if it existed
    if [ -f "$shell_histfile.old" ]; then
        mv "$shell_histfile.old" "$shell_histfile"
    fi
}

@test "can run cqfd shell script" {
    run cqfd init
    assert_success

    run cqfd
    assert_success
}

@test "bash: commands run are saved in the history file" {
   shell-vars-setup "bash"
   run-posix-commands "bash"
}

@test "zsh: commands run are saved in the history file" {
   shell-vars-setup "zsh"
   run-posix-commands "zsh"
}

@test "ksh: commands run are saved in the history file" {
   shell-vars-setup "ksh"
   run-posix-commands "ksh"
}
