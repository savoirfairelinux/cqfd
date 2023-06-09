# ChangeLog for cqfd

## Version 5.5.0-dev (coming soon)

* Stay tuned!

## Version 5.4.0 (2023-06-09)

* Changes to the `Dockerfile` since the last `init` are now detected, and will
  raise an error.
* Add the `-c` option to cqfd run/release, to pass extra arguments to the
  pre-defined command.
* The host's `/etc/ssh` directory is now mapped into the container, to pass
  `ssh` clients running in the container the same configuration as on the host.
  Cqfd historically mapped `~/.ssh` into the container for similar reasons. Note
  this feature can be disabled using the `CQFD_NO_SSH_CONFIG` environment
  variable.
* The `flavors=` parameter is not required anymore, as extra flavors in the
  config file are automatically detected.
* When in a project sub-directory, try to locate the `.cqfd` context in parent
  directories automatically.

## Version 5.3.0 (2022-01-05)

* Add the `docker_run_args` .cqfdrc option.
* Misc. documentation fixes.

## Version 5.2.1 (2020-09-14)

* Fixed an error when launching `cqfd run` from a working directory with
  spaces in its hierarchy.
* Misc. fixes to the integrated test suite.

## Version 5.2.0 (2020-11-11)

* Add the `-d` option to specify an alternate cqfd directory.
* Add the `-C` option to change the working directory.
* Date strings now use POSIX options, eg. for running on macOS.
* Containers are now named `cqfd_%user_%company_%project` instead of
  `cqfd_%company_%project`. This prevents collisions with Docker when
  several users are using it on the same machine.
* Add `tar_options` cqfd option to add extra options to tar command.
* Add CQFD_EXTRA_BUILD_ARGS to pass args and options to the image build process.

## Version 5.1.0 (2019-05-13)

* The launcher script in the container now gives extra infos in
  case of failure.
* ``sudo(8)`` is now used to run the commands as the unprivileged user
  in the container instead of ``su(1)``.
* The ``project.build_context`` key allows changing the docker-build
  context directory.
* Options `-v` and `--version` now behave appropriately

## Version 5.0.1 (2018-12-13)

* Fix wrong user homedir in container when host user isn't in /home
* Terminate cqfd in case a legacy CQFD_EXTRA_* variable is used.

## Version 5.0.0

* Use semantic versioning
* CQFD_EXTRA_RUN_ARGS replaces CQFD_EXTRA_VOLUMES,ENV,HOSTS,PORTS.
* The container's user and work directory are now the same as the
  invocating user. This is useful to prevent cases where the build
  process generates symlinks or paths in files that don't match the
  developer's environment.
* New cqfd [-v|--version] to print the version

## Version 4

* Files in an archive are only moved at its root if tar_transform is set to yes.
* Added support for .tar.gz and .zip archives.
* Default archive filename is now named after the project's configuration.
* Remove the release config section
* Allow templating the release filename
* Preserve container environment into the build user's shell

## Version 3

* Support multiple build flavors
* Support user-specified volume mappings ($CQFD_EXTRA_VOLUMES)

## Version 2

* Fix config parser issue on bash >4.1
* Use action verbs in user interface
* Do not have user depend on SSH_AUTH_SOCK

## Version 1

* Initial release
* Support for Ubuntu (trusty) build containers

