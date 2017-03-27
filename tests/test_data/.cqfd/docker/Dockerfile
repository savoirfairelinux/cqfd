FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /home/builder
ENV SSH_AUTH_SOCK /home/builder/.sockets/ssh

RUN apt-get update && apt-get install -y --no-install-recommends make

WORKDIR /home/builder/src
VOLUME /home/builder/src
