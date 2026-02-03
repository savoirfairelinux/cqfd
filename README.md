![cqfd logo](./doc/cqfd_logo.png?raw=true)

# What is cqfd?

cqfd provides a quick and convenient way to run commands in the current
directory within a Docker container defined by a per-project configuration
file.

This becomes useful when building an application designed for another
Linux system, e.g. building an old embedded firmware that only works
in an older Linux distribution.

# Using cqfd

## Getting started

Follow these steps:

* Ensure the [requirements](#requirements) are met
* [**Install cqfd**](#installingremoving-cqfd)
* Go to your project's directory
* Create a `.cqfdrc` file
* Create a Dockerfile and save it as `.cqfd/docker/Dockerfile`
* Run `cqfd init`

Examples are available in the `samples/` directory.

`cqfd` will use the provided Dockerfile to create a normalized runtime
build environment for your project.

## Installing/removing cqfd

### From packages

#### Ubuntu or Debian

First download the package, then install it with the package manager:

```sh
curl -LO https://github.com/savoirfairelinux/cqfd/releases/download/v5.9.0/cqfd_5.9.0_all.deb
sudo apt install ./cqfd_5.9.0_all.deb
```

_Note_: Uninstall it using the package manager:

```sh
sudo apt remove cqfd
```

#### Fedora or RedHat Linux

First download the package, then install it with the package manager:

```sh
curl -LO https://github.com/savoirfairelinux/cqfd/releases/download/v5.9.0/cqfd-5.9.0-1.noarch.rpm
sudo dnf install ./cqfd-5.9.0-1.noarch.rpm
```

_Note_: Uninstall it using the package manager:

```sh
sudo dnf remove cqfd
```

#### Arch Linux or Manjaro

First download the package, then install it with the package manager:

```sh
curl -LO https://github.com/savoirfairelinux/cqfd/releases/download/v5.9.0/cqfd-5.9.0-1-any.pkg.tar.zst
sudo pacman -U ./cqfd-5.9.0-1-any.pkg.tar.zst
```

_Note_: Uninstall it using the package manager:

```sh
sudo pacman -R cqfd
```

#### GNU Guix

If you use the [GNU Guix](https://gnu.org/software/guix) package
manager, you can install `cqfd` via:

```sh
guix install cqfd
```

### From source

First clone this repository, then checkout the stable version, and install cqfd
and its resources:

```sh
git clone --recurse-submodules https://github.com/savoirfairelinux/cqfd.git
cd cqfd
git checkout v5.9.0
sudo make install
```

To uninstall the script and its resources, run:

```sh
sudo make uninstall
```

Makefile honors both **PREFIX** (__/usr/local__) and **DESTDIR** (__[empty]__)
variables:

```sh
make install PREFIX=/opt
make install PREFIX=/usr DESTDIR=package
```

## Using cqfd on a daily basis

### Regular builds

To build your project from the configured build environment with the
default build command as configured in `.cqfdrc`, use:

```sh
cqfd
```

Alternatively, you may want to specify a custom command to be
executed from inside the build container.

```sh
cqfd run make clean
cqfd run "make linux-dirclean && make foobar-dirclean"
```

The `run` command is broken in some situations, and it is then recommended to
use `exec` for a single command, `shell -c` for a command composed with shell
grammar, or `shell` to run a shell script with or without arguments:

```sh
cqfd exec make clean
cqfd shell -c "make linux-dirclean && make foobar-dirclean"
cqfd shell ./build.sh debug
```

When `cqfd` is running, the current directory is mounted by Docker
as a volume. As a result, all the build artefacts generated inside the
container are still accessible in this directory after the container
has been stopped and removed.

### Release

The `release` command behaves exactly like `run`, but creates a release
tarball for your project additionally. The release files (as specified
in your `.cqfdrc`) will be included inside the release archive.

```sh
cqfd release
```

The resulting release file is then called according to the archive
template, which defaults to `%Po-%Pn.tar.xz`.

### Flavors

Flavors are used to create alternate build scenarios. For example, to
use another container or another build command.

## The .cqfdrc file

The `.cqfdrc` file at the root of your project contains the information
required to support project tooling. It is written in an .ini-like
format and `samples/dot-cqfdrc` is an example.

Here is a sample `.cqfdrc` file:

```ini
[project]
org='fooinc'
name='buildroot'

[build]
command='make foobar_defconfig && make && asciidoc README.FOOINC'
files='README.FOOINC output/images/sdcard.img'
archive='cqfd-%Gh.tar.xz'
```

### Comments

The `.cqfdrc` file supports Unix shell comments; the words after the character `#`
are ignored up to the end of line. A comment cannot be set in the first line,
and right after a section.

### The [project] section

`org`: a short, lowercase name for the project’s parent organization.

`name`: a short, lowercase name for the project.

`build_context` (optional): a directory to pass as the build context
to Docker. This should be specified relatively to where `cqfd` is
invoked.  For example, it can be set to `.`, to use the current
working directory of the invoked `cqfd` command as the Docker build
context, which can be useful when files at the root of the project are
required to build the image.  When using this option, a
`.dockerignore` file can be useful to limit what gets sent to the
Docker daemon.

`custom_img_name` (optional): allows specifying a custom Docker image name
instead of the one automatically generated by cqfd. You can also include a
private repository URL in the image name. If you do, cqfd will try to pull the
image from the provided repository, if not already available on your system.

#### Docker image naming

Unless `custom_img_name` is used, Docker images generated by cqfd will be
named `cqfd_$username_$org_$name_$hash`, using the following variables:

* `$username`: The UNIX username used to launch cqfd.
* `$org`: The `org` variable in the `[project]` section of your `.cqfdrc`.
* `$name`: The `name` variable in the `[project]` section of your `.cqfdrc`.
* `$hash`: A hash of the local Dockerfile.

### The [build] section

#### `cqfd run`

`command`: the command string to be executed when cqfd is invoked. This
string will be passed as an argument to a classical `sh -c "commands"`,
within the build container, to generate the build artefacts.

`distro` (optional): the name of the directory containing the Dockerfile. By
default, cqfd uses `"docker"`, and `.cqfd/docker/Dockerfile` is used.

`user_extra_groups` (optional): a space-separated list of groups the user
should be a member of in the container. You can either use the `group:gid`
format, or simply specify the `group` name if it exists either in the host or
inside the docker image.

`flavors` (optional): the list of build flavors (see below). Each flavor has
its own command just like `build.command`. This property is now automatically
deduced from the flavors sections of `.cqfdrc`.

`docker_build_args` (optional): arguments used to invoke `docker build`.
For example, to attempt to pull newer version of the image, it can be set like:
```
docker_build_args='--pull=true'
```

`docker_run_args` (optional): arguments used to invoke `docker run`.
For example, to share networking with the host, it can be set like:
```
docker_run_args='--network=host'
```

`docker_rmi_args` (optional): arguments used to invoke `docker rmi`.
For example, to force removal of the image, it can be set like:
```
docker_rmi_args='--force'
```

`bind_docker_sock` (optional): set to `true` to enable forwarding the
docker socket to the container. This equivalent to the environment variable
`CQFD_BIND_DOCKER_SOCK`.
```
bind_docker_sock='true'
```

#### `cqfd release`

`files`: the space-separated list of files generated by the build process
that we want to include inside a standard release archive.

`archive` (optional): the name of the release archive generated by cqfd. You
can include environment variable names, as well as the following template
marks:

* `%Gh` - git short hash of last commit
* `%GH` - git long hash of last commit
* `%D3` - RFC3339 date (YYYY-MM-DD)
* `%Du` - Unix timestamp
* `%Cf` - current cqfd flavor name (if any)
* `%Po` - value of the `project.org` configuration key
* `%Pn` - value of the `project.name` configuration key
* `%%` - a litteral '%' sign

By default, cqfd will generate a release archive named
`org-name.tar.xz`, where 'org' and 'name' come from the project's
configuration keys. The .tar.xz, .tar.gz and .zip archive formats are
supported.

For tar archives:

* Setting `tar_transform=yes` (optional) will cause all files specified for
  the archive to be stored at the root of the archive, which is desired in some
  scenarios.

* Setting `tar_options` (optional) will pass extra options to the tar
  command. For example, setting `tar_options=-h` will copy all symlink files
  as hardlinks, which is desired in some scenarios.

### Using build flavors

In some cases, it may be desirable to build the project using
variations of the build and release methods (for example a debug
build). This is made possible in cqfd with the build flavors feature.

In the `.cqfdrc` file, one or more flavors may be listed in the
`[build]` section, referencing other sections named following
flavor's name.

```ini
[centos7]
command='make CENTOS=1'
distro='centos7'

[debug]
command='make DEBUG=1'
files='myprogram Symbols.map'

[build]
command='make'
files='myprogram'
```

A flavor will typically redefine some keys of the build section:
command, files, archive, distro.

Flavors from a `.cqfdrc` file can be listed using the `flavors` argument.

## cqfd features

### Environment variables

The following environment variables are supported by cqfd to provide
the user with extra flexibility during his day-to-day development
tasks:

`CQFD_DOCKER`: program used to invoke `docker` client.
For example, to use docker if not in the docker group, it can be set like:
```
CQFD_DOCKER='sudo docker'
```

`CQFD_EXTRA_RUN_ARGS`: A space-separated list of additional
docker-run options to be append to the starting container.
Format is the same as (and passed to) docker-run’s options.
See 'docker run --help'.

`CQFD_EXTRA_BUILD_ARGS`: A space-separated list of additional
docker-build options to be append to the building image.
Format is the same as (and passed to) docker-build’s options.
See 'docker build --help'.

`CQFD_EXTRA_RMI_ARGS`: A space-separated list of additional
docker-rmi options to be append to the removed image.
Format is the same as (and passed to) docker-rmi’s options.
See 'docker rmi --help'.

`CQFD_NO_SSH_CONFIG`: Set to `true` to disable forwarding the global
`/etc/ssh` configurations to the container. This may be required if
the host's `ssh` configuration is not compatible with the `ssh`
version within the container.

`CQFD_NO_USER_SSH_CONFIG`: Set to `true` to disable forwarding
the user's `~/.ssh` configuration to the container.

`CQFD_NO_USER_GIT_CONFIG`: Set to `true` to disable forwarding
the user's `~/.gitconfig` configuration to the container.

`CQFD_NO_SSH_AUTH_SOCK`: Set to `true` to disable forwarding the
SSH authentication socket to the container.

`CQFD_BIND_DOCKER_SOCK`: Set to `true` to enable forwarding the
docker socket to the container.

`CQFD_DOCKER_GID`: The gid of the docker group in host to map to
the cqfd group in the container.

`CQFD_SHELL`: The shell to be launched, by default `/bin/sh`.

`CQFD_DISABLE_SHELL_HISTORY`: Set to `true` to disable bind mounting the shell
history file in the container and setting the HISTFILE variable

### Appending to the build command

The `-c` option set immediately after the command run allows appending the
command of a cqfd run for temporary developments:

```sh
cqfd -b centos7 run -c "clean"
cqfd -b centos7 run -c "TRACING=1"
```

### Running a shell in the container

You can use the `shell` command to quickly pop a shell in your defined
container. The shell to be launched (default `/bin/sh`) can be customized using
the `CQFD_SHELL` environment variable.

Example:

```sh
fred@host:~/project$ cqfd shell
fred@container:~/project$
```

### Use cqfd as an interpreter for shell script

You can use the `shell` command to write a shell script and run it in your
defined container.

Example:

```sh
fred@host:~/project$ cat get-container-pretty-name.sh 
#!/usr/bin/env -S cqfd shell
if ! test -e /.dockerenv; then
    exit 1
fi
source /etc/os-release
echo "$PRETTY_NAME"
fred@host:~/project$ ./get-container-pretty-name.sh 
Debian GNU/Linux 12 (bookworm)
```

### Use cqfd as a standard shell for binaries

You can even use the `shell` command to use it as a standard `$SHELL` so
binaries honoring that variable run shell commands in your defined container.

Example:

```sh
fred@host:~/project$ make SHELL="cqfd shell"
Available make targets:
    help:      This help message
    install:   Install script, doc and resources
    uninstall: Remove script, doc and resources
    tests:     Run functional tests
```

### Other command-line options

In some conditions you may want to use alternate cqfd filenames and / or an
external working directory. These options can be used to control the cqfd
configuration files:

The working directory can be changed using the `-C` option:

```sh
cqfd -C external/directory
```

An alternate cqfd directory can be specified with the `-d` option:

```sh
cqfd -d cqfd_alt
```

An alternate cqfdrc file can be specified with the `-f` option:

```sh
cqfd -f cqfdrc_alt
```

These options can be combined:

```sh
cqfd -C external/directory -d cqfd_alt -f cqfdrc_alt
# cqfd will use:
#  - cqfd directory: external/directory/cqfd_alt
#  - cqfdrc file: external/directory/cqfdrc_alt
```

### Shell history

`cqfd` bind mounts the current shell history file to the container so the
commands history is shared between the user and the cqfd container. This feature
is supported for `bash`, `zsh`, `tcsh`, and `ksh`.

This feature is available only when using the commands `cqfd shell`, `cqfd <name_of_the_shell>`
such as `cqfd bash`, `cqfd run <name_of_the_shell>` and
`cqfd exec <name_of_the_shell>`.

## Build Container Environment

When cqfd runs, a docker container is launched as the environment in
which to run the *command*.  Within this environment, commands are run
as the same user as the one invoking cqfd (with a fallback to the
'builder' user in case it cannot be determined). So that this user has
access to local files, the current working directory is mapped to
the same location inside the container.

### SSH Handling

The local ~/.ssh directory is also mapped to the corresponding
directory in the build container. This effectively enables SSH agent
forwarding so a build can, for example, pull authenticated git repos.

### Terminal job control

When cqfd runs a command as the unprivileged user that called it in
the first place, `su(1)` is used to run the command. This brings a
limitation for processes that require a controlling terminal (such as
an interactive shell), as `su` will prevent the command executed
from having one.

```sh
$ cqfd bash
bash: cannot set terminal process group (-1): Inappropriate ioctl for device
bash: no job control in this shell
```

To work around this limitation, cqfd will use `sudo(8)` when it is
available in the container instead. The user is responsible for
including it in the related Dockerfile.

## Remove images

Running `cqfd init` creates and names a new Docker image each
time the Dockerfile is modified, which may lead to a large number of
unused images that are not automatically purged.

To remove the image associated with the current version of the Dockerfile, use:

```sh
cqfd deinit
```

If a flavor redefines the distro key of the build section, use:

```sh
cqfd -b centos7 deinit
```

To list all cqfd images across all user projects on the system, use:

```sh
cqfd images
```

To clean all cqfd images across all user projects on the system, use:

```sh
cqfd prune
```

## Requirements

To use cqfd, ensure the following requirements are satisfied on your
workstation:

- Bash
- Docker
- A `docker` group in your `/etc/group`
- Your username is a member of the `docker` group
- Restart your docker service if you needed to create the group.

## Building cqfd packages

After having cloned the source of cqfd, you can build the packages for the
following Linux distributions:

### Ubuntu or Debian

If you use an Debian derivative distribution based on the dpkg package manager,
you can build the latest released version of the `cqfd` package via:

```sh
dpkg-buildpackage -us -uc
```

_Note_: The artefacts are available in the parent directory.

### Fedora or RedHat Linux

If you use an RPM based distribution, you can build the latest released version
of the `cqfd` package via:

```sh
rpmdev-setuptree
cp cqfd.spec ~/rpmbuild/SPECS/
cd ~/rpmbuild/SPECS
rpmbuild --undefine=_disable_source_fetch -ba cqfd.spec "$@"
cp ~/rpmbuild/SRPMS/*.src.rpm ~/rpmbuild/RPMS/*/*.rpm "$OLDPWD"
```

_Note_: The artefacts are available in `~/rpmbuild/RPMS` and `~/rpmbuild/SRPMS`
directories.

### Arch Linux or Manjaro

If you use an Arch Linux derivative distribution based on pacman package
manager, you can build the latest released version of the `cqfd` package via:

```sh
makepkg
```

Or, the current unreleased version of the `cqfd-git` package via:

```sh
makepkg -f PKGBUILD-git
```

_Note_: The artefacts are available in the current directory.

## Using podman

Podman may be used instead of Docker. It first must be installed on your system,
and then, to use it instead of docker, you can set in your environment,
like your `.bashrc`, `.profile` or `.zshrc`:

```bash
export CQFD_DOCKER="podman"
```

You can also prefix your cqfd commands:

```bash
CQFD_DOCKER="podman" cqfd init
CQFD_DOCKER="podman" cqfd shell
```

## Testing cqfd (for developers)

The codebase contains tests which can be invoked using the following
command, if the [requirements](#requirements) are met on the system:

```sh
make tests
```

The test suite depends on a git submodule, so if they do not run it may be
because submodule have not been synced. To sync them, use:

```sh
git submodule update --init --recursive
```

## Patches

Submit patches at *https://github.com/savoirfairelinux/cqfd/pulls*

## Bugs

Report bugs at *https://github.com/savoirfairelinux/cqfd/issues*

## Trivia

CQFD stands for "ce qu'il fallait Dockeriser", French for "what needed
to be Dockerized".
