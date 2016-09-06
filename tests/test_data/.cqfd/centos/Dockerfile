FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update

ENV LANG en_US.utf8
ENV LC_ALL en_US.utf8
ENV HOME /home/builder
ENV SSH_AUTH_SOCK /home/builder/.sockets/ssh

WORKDIR /home/builder/src
VOLUME /home/builder/src

