FROM debian:latest
ENV DPKG_FRONTEND=noninteractive
RUN apt-get -y update && apt-get -y install asciidoctor bash-completion build-essential debhelper devscripts pkgconf shellcheck
CMD ["dpkg-buildpackage", "-us", "-uc"]
