#!/usr/bin/env bats

setup() {
    load 'test_helper/common-setup'
    _common_setup
    HISTFILE=$(mktemp "/tmp/tmp.bats-cqfd-XXXXX")
    export HISTFILE
    shell_histfile=${HISTFILE}
}

run_shell_commands() {
    shell_name="$1"
    rm_histfile="$2"
    exec_or_run="$3"
    string_to_check="hello from the other side $shell_name"
    commands_file="$BATS_TEST_TMPDIR/commands.txt"

    echo "echo $string_to_check" > "$commands_file"

    if [ "$rm_histfile" = "true" ] && [ -f "$shell_histfile" ]; then
        rm -f "$shell_histfile"
    fi

    if [ -n "$exec_or_run" ]; then
        case "$exec_or_run" in
        exec)
            run cqfd exec "$shell_name" -i < "$commands_file"
            assert_success
        ;;
        run)
            run cqfd run "$shell_name" -i < "$commands_file"
            assert_success
        ;;
        esac
    else
        run cqfd "$shell_name" -i < "$commands_file"
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

@test "bash: commands run are saved in the history file" {
    run_shell_commands "bash" "" ""
}

@test "zsh: commands run are saved in the history file" {
    run_shell_commands "zsh" "" ""
}

@test "ksh: commands run are saved in the history file" {
    run_shell_commands "ksh" "" ""
}

@test "bash: shell history file is created if it does not already exist" {
    run_shell_commands "bash" "true" ""
}

@test "zsh: shell history file is created if it does not already exist" {
    run_shell_commands "zsh" "true" ""
}

@test "ksh: shell history file is created if it does not already exist" {
    run_shell_commands "ksh" "true" ""
}

@test "bash: history saving functions as expected when cqfd is called with run" {
    run_shell_commands "bash" "true" "run"
}

@test "zsh: history saving functions as expected when cqfd is called with run" {
    run_shell_commands "zsh" "true" "run"
}

@test "ksh: history saving functions as expected when cqfd is called with run" {
    run_shell_commands "ksh" "true" "run"
}

@test "bash: history saving functions as expected when cqfd is called with exec" {
    run_shell_commands "bash" "true" "exec"
}

@test "zsh: history saving functions as expected when cqfd is called with exec" {
    run_shell_commands "zsh" "true" "exec"
}

@test "ksh: history saving functions as expected when cqfd is called with exec" {
    run_shell_commands "ksh" "true" "exec"
}
