#!/usr/bin/env bats

setup_file() {
    cp -f .cqfdrc .cqfdrc.old
}

setup() {
    load 'test_helper/common-setup'
    _common_setup
    rel_files="a/cqfd_a.txt a/b/c/cqfd_c.txt a/b/cqfd_b.txt"
    export CTEST=foobar
}

teardown_file() {
    mv -f .cqfdrc.old .cqfdrc
}

@test "cqfd release fails without files parameter" {
    run cqfd release
    assert_failure
}

@test "cqfd release now with a files parameter" {
    echo "files=\"$rel_files\"" >>.cqfdrc
    run cqfd release
    assert_success
}

@test "default orgname-project.tar.xz archive is generated" {
    run tar tf cqfd-test.tar.xz
    assert_success
}

@test "archived files NOT at root of tar archive" {
    result="pass"
    for f in $rel_files; do
        if ! tar tf cqfd-test.tar.xz | grep -q "^$f$"; then
            result="fail"
        fi
    done
    run [ "$result" = "pass" ]
    assert_success
    rm -f cqfd-test.tar.xz
}

@test "archived files NOT at root of tar archive if tar_transform=no" {
    echo "tar_transform=no" >>.cqfdrc
    cqfd release
    result="pass"
    for f in $rel_files; do
        if ! tar tf cqfd-test.tar.xz | grep -q "^$f$"; then
            result="fail"
        fi
    done
    run [ "$result" = "pass" ]
    assert_success
    sed -i -e '$ s!^tar_transform=.*$!!' .cqfdrc
    rm -f cqfd-test.tar.xz
}

@test "archived files at root of tar archive if tar_transform=yes" {
    echo "tar_transform=yes" >>.cqfdrc
    cqfd release
    result="pass"
    for f in $rel_files; do
        if ! tar tf cqfd-test.tar.xz | grep -q "^$(basename "$f")$"; then
            result="fail"
        fi
    done
    run [ "$result" = "pass" ]
    assert_success
    sed -i -e '$ s!^tar_transform=.*$!!' .cqfdrc
    rm -f cqfd-test.tar.xz
}

@test "symlink files are copied in the tar archive" {
    cqfd run ln -s a/cqfd_a.txt link.txt
    rel_files_link="a/cqfd_a.txt link.txt"
    sed -i '/files=/d' .cqfdrc
    echo "files=\"$rel_files_link\"" >>.cqfdrc
    echo "tar_options=-h" >>.cqfdrc

    cqfd release
    result="pass"
    tmp_dir=$(mktemp -d)
    if ! tar xf cqfd-test.tar.xz -C "$tmp_dir"; then
        result="fail"
    fi

    if [ -L "$tmp_dir"/link.txt ] || ! diff "$tmp_dir"/a/cqfd_a.txt "$tmp_dir"/link.txt; then
        result="fail"
    fi

    run [ "$result" = "pass" ]
    assert_success

    # revert the changes in .cqfdrc file
    rm -f link.txt
    sed -i '/tar_options=/d' .cqfdrc
    sed -i '/files=/d' .cqfdrc
    echo "files=\"$rel_files\"" >>.cqfdrc

    rm -f cqfd-test.tar.xz
    rm -rf "$tmp_dir"
}

@test "build.archive can template filenames (RFC3339 date)" {
    d3=$(date --rfc-3339='date')
    # shellcheck disable=SC2016
    echo 'archive=cqfd-%D3-$CTEST.tar.xz' >>.cqfdrc
    run cqfd release
    assert_success
    run tar tf "cqfd-$d3-foobar.tar.xz"
    assert_success
    rm -f "cqfd-$d3-foobar.tar.xz"
}

@test "build.archive can template filenames (git short hash of last commit)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*$!archive=cqfd-%Gh-$CTEST.tar.xz!' .cqfdrc
    # shellcheck disable=SC2010
    GIT_DIR="$PROJECT_ROOT/.git" run cqfd release
    assert_success
    run ls -1 cqfd-*-foobar.tar.xz
    assert_line --regexp "^cqfd-[[:xdigit:]]{4,40}-foobar.tar.xz$"
    run tar tf cqfd-*-foobar.tar.xz
    assert_success
    rm -f cqfd-*-foobar.tar.xz
}

@test "build.archive can template filenames (git long hash of last commit)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*$!archive=cqfd-%GH-$CTEST.tar.xz!' .cqfdrc
    # shellcheck disable=SC2010
    GIT_DIR="$PROJECT_ROOT/.git" run cqfd release
    assert_success
    run ls -1 cqfd-*-foobar.tar.xz
    assert_line --regexp "^cqfd-[[:xdigit:]]{40}-foobar.tar.xz$"
    run tar tf cqfd-*-foobar.tar.xz
    assert_success
    rm -f cqfd-*-foobar.tar.xz
}

@test "build.archive can template filenames (Unix timestamp)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*$!archive=cqfd-%Du-$CTEST.tar.xz!' .cqfdrc
    # shellcheck disable=SC2010
    run cqfd release
    assert_success
    run ls -1 cqfd-*-foobar.tar.xz 
    assert_line --regexp "^cqfd-[[:digit:]]{1,20}-foobar.tar.xz$"
    run tar tf cqfd-*-foobar.tar.xz
    assert_success
    rm -f cqfd-*-foobar.tar.xz
}

@test "build.archive can template filenames (current cqfd flavor name unset)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*$!archive=cqfd-%Cf-$CTEST.tar.xz!' .cqfdrc
    run cqfd release
    assert_success
    run tar tf cqfd--foobar.tar.xz
    assert_success
    rm -f cqfd--foobar.tar.xz
}

@test "build.archive can template filenames (current cqfd flavor name set)" {
    run cqfd -b foo release
    assert_success
    run tar tf cqfd-foo.tar.xz
    assert_success
    rm -f cqfd-foo.tar.xz
}

@test "build.archive can template filenames (value of the project.org configuration key)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*$!archive=cqfd-%Po-$CTEST.tar.xz!' .cqfdrc
    run cqfd release
    assert_success
    run tar tf cqfd-cqfd-foobar.tar.xz
    assert_success
    rm -f cqfd-cqfd-foobar.tar.xz
}

@test "build.archive can template filenames (value of the project.name configuration key)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*$!archive=cqfd-%Pn-$CTEST.tar.xz!' .cqfdrc
    run cqfd release
    assert_success
    run tar tf cqfd-test-foobar.tar.xz
    assert_success
    rm -f cqfd-test-foobar.tar.xz
}

@test "build.archive can template filenames (litteral '%' sign)" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*!archive=cqfd-%%-$CTEST.tar.xz!' .cqfdrc
    run cqfd release
    assert_success
    run tar tf cqfd-%-foobar.tar.xz
    assert_success
    rm -f cqfd-%-foobar.tar.xz
}

@test "build.archive can make a .tar.gz archive" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*xz$!archive=cqfd-$CTEST.tar.gz!' .cqfdrc
    run cqfd release
    assert_success
    run tar ztf "cqfd-$CTEST.tar.gz"
    assert_success
    rm -f "cqfd-$CTEST.tar.gz"
}

@test "build.archive can make a .zip archive" {
    # shellcheck disable=SC2016
    sed -i -e '$ s!^archive=.*gz$!archive=cqfd-$CTEST.zip!' .cqfdrc
    run cqfd release
    assert_success
    run unzip -l "cqfd-$CTEST.zip"
    assert_success
    rm -f "cqfd-$CTEST.zip"
}

@test "release for flavor foo creates cqfd-foo.tar.xz" {
    filename="cqfd-foo.tar.xz"
    run cqfd -b "foo" release
    assert_success
    run tar tf "$filename"
    assert_success
    rm -f "$filename"
}

@test "release for flavor bar creates cqfd-bar.tar.xz" {
    filename="cqfd-bar.tar.xz"
    run cqfd -b "bar" release
    assert_success
    run tar tf "$filename"
    assert_success
    rm -f "$filename"
}

@test "cqfd fails on missing file in build.files" {
    sed -i -e 's!^files=.*$!files="ThisFileDoesNotExist.txt"!' .cqfdrc
    run cqfd release
    assert_failure
}

@test "cqfd resolves globs in build.files" {
    # shellcheck disable=SC2016
    sed -i -e 's!^archive=.*$!archive=cqfd-$CTEST.tar.xz!' .cqfdrc
    sed -i -e 's!^files=.*$!files=".cq*rc Ma*"!' .cqfdrc
    # cqfd release must work without error
    run cqfd release
    assert_success
}

# the generated archive should contain our expanded globs
@test "resolved globs are properly archived" {
    run tar tf "cqfd-$CTEST.tar.xz"
    assert_line --regexp '^.cqfdrc$'
    assert_line --regexp '^Makefile$'
    # cleanup
    rm -f "cqfd-$CTEST.tar.xz"
}

