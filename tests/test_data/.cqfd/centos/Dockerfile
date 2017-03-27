FROM centos:centos7
MAINTAINER The CentOS Project <cloud-ops@centos.org>

RUN yum -y update

ENV HOME /home/builder
ENV SSH_AUTH_SOCK /home/builder/.sockets/ssh

WORKDIR /home/builder/src
VOLUME /home/builder/src

