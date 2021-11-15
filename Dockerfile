# syntax=docker/dockerfile:1

FROM ruby:2.7-bullseye AS ruby

FROM ubuntu:latest

RUN apt-get update \
	&& ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
	&& apt-get install -y --no-install-recommends \
	libssl-dev bash curl ca-certificates wget make tar git make less \
	openssh-client procps dnsutils whois netcat tcpdump tcptrace sipcalc \
	perl tig tmux tree pwgen unzip nmap gpg tzdata xz-utils python3 python3-pip \
	&& dpkg-reconfigure --frontend noninteractive tzdata \
  && echo hosts: files dns > /etc/nsswitch.conf

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tshark 

COPY --from=ruby /usr/local /usr/local

WORKDIR /root

ADD ./bin/fly-wrapper /usr/local/bin/fly

ADD ./bin/build /root/build
RUN /root/build

CMD /bin/bash

