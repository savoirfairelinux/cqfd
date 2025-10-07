#!/usr/bin/env bats

@test "can run cqfd shell script" {
    ./cqfd init
    ./cqfd
}
