#!/usr/bin/env bats
load 'test_helper/bats-support/load'
load 'test_helper/bats-assert/load'

# Setup so that bats tests can be run from anywhere
setup() {
    # Export to $PATH so that cqfd can be run without ./
    export PATH="$BATS_TEST_DIRNAME/../:$PATH"
}

setup_histfile() {
    export HISTFILE=$(mktemp "/tmp/tmp.bats-cqfd-XXXXX")
    shell_histfile=${HISTFILE}
}

run_shell_commands() {
    shell_name="$1"
    rm_histfile="$2"
    exec_or_run="$3"
    string_to_check="hello from the other side $shell_name"
    commands_file=$(mktemp "/tmp/tmp.bats-cqfd-XXXXXXXX")

    echo "echo $string_to_check" >> "$commands_file"

    if [ "$rm_histfile" = "true" ] && [ -f "$shell_histfile" ]; then
        rm -f "$shell_histfile"
    fi

    if [ -n "$exec_or_run" ]; then
        case "$exec_or_run" in
        exec)
            run ./cqfd exec "$shell_name" -i < "$commands_file"
            assert_success
        ;;
        run)
            run ./cqfd run "$shell_name" -i < "$commands_file"
            assert_success
        ;;
        esac
    else
        run ./cqfd "$shell_name" -i < "$commands_file"
        assert_success
    fi

    # test that the shell commands have been run from the commands file
    assert_line --partial "$string_to_check"

    # test that the commands run are now in the $shell_histfile
    if [ -f "$shell_histfile" ]; then
        run tail "$shell_histfile"
        assert_line --partial "echo $string_to_check"
    else
        assert_failure "shell history file not found"
    fi
}

@test "can run cqfd shell script" {
    run ./cqfd init
    assert_success

    run ./cqfd
    assert_success
}

@test "bash: commands run are saved in the history file" {
   setup_histfile
   run_shell_commands "bash" "" ""
}

@test "zsh: commands run are saved in the history file" {
   setup_histfile
   run_shell_commands "zsh" "" ""
}

@test "ksh: commands run are saved in the history file" {
   setup_histfile
   run_shell_commands "ksh" "" ""
}

@test "bash: shell history file is created if it does not already exist" {
    setup_histfile
    run_shell_commands "bash" "true" ""
}

@test "zsh: shell history file is created if it does not already exist" {
    setup_histfile
    run_shell_commands "zsh" "true" ""
}

@test "ksh: shell history file is created if it does not already exist" {
    setup_histfile
    run_shell_commands "ksh" "true" ""
}

@test "bash: history saving functions as expected when cqfd is called with run" {
    setup_histfile
    run_shell_commands "bash" "true" "run"
}

@test "zsh: history saving functions as expected when cqfd is called with run" {
    setup_histfile
    run_shell_commands "zsh" "true" "run"
}

@test "ksh: history saving functions as expected when cqfd is called with run" {
    setup_histfile
    run_shell_commands "ksh" "true" "run"
}

@test "bash: history saving functions as expected when cqfd is called with exec" {
    setup_histfile
    run_shell_commands "bash" "true" "exec"
}

@test "zsh: history saving functions as expected when cqfd is called with exec" {
    setup_histfile
    run_shell_commands "zsh" "true" "exec"
}

@test "ksh: history saving functions as expected when cqfd is called with exec" {
    setup_histfile
    run_shell_commands "ksh" "true" "exec"
}
