FROM ubuntu:14.04

ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV HOME /home/builder
ENV SSH_AUTH_SOCK /home/builder/.sockets/ssh

RUN apt-get update && apt-get install -y --no-install-recommends make
RUN locale-gen $LANG $LC_ALL && update-locale $LANG $LC_ALL

WORKDIR /home/builder/src
VOLUME /home/builder/src
