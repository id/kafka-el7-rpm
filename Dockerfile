# default build is for CentOS7, change the base image to fit your build.
FROM centos:centos7
MAINTAINER Sebastien Le Digabel "sledigabel@gmail.com"

RUN yum install -y wget make rpmdevtools

ADD Makefile kafka.logrotate kafka.service kafka.spec kafka.sysconfig kafka.log4j.properties kafka-graphite-*.jar /root/

RUN mkdir /root/RPMS

WORKDIR /root

VOLUME ["/root/RPMS"]

CMD make
