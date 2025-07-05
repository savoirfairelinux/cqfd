FROM fedora:42
RUN dnf install -y asciidoctor bash-completion-devel gcc git make pkgconf rpmdevtools rpmlint shellcheck
CMD ["rpmbuild", "--undefine=_disable_source_fetch", "-ba", "cqfd.specs"]
