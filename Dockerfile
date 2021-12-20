# syntax=docker/dockerfile:1

FROM ruby:2.7-bullseye AS ruby

FROM starkandwayne/carousel-concourse AS carousel

FROM ubuntu:latest

RUN apt-get update \
	&& ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime \
	&& apt-get install -y --no-install-recommends  build-essential \
	libssl-dev bash curl ca-certificates wget tar git less file \
	openssh-client procps dnsutils whois netcat tcpdump tcptrace sipcalc \
	perl tig tmux tree pwgen unzip nmap gnupg2 tzdata xz-utils python3 python3-pip \
	&& dpkg-reconfigure --frontend noninteractive tzdata \
  && echo hosts: files dns > /etc/nsswitch.conf

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tshark 

COPY --from=ruby /usr/local /usr/local
COPY --from=carousel /bin/carousel /bin/carousel

ADD ./bin/fly-wrapper /usr/local/bin/fly
ADD ./bin/cf-wrapper /usr/local/bin/cf
ADD ./bin/yamler /usr/local/bin/fly

WORKDIR /build

ADD ./bin/build /build/build

RUN /build/build

CMD /bin/bash
