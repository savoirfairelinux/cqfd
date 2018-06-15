# ChangeLog for cqfd

## Those changes will be in version 5

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

