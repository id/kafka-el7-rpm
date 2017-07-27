# kafka-redhat7-rpm

A set of scripts to package kafka into an rpm.

Requires CentOS/RedHat 7 or Docker.

# Prerequisites

    sudo yum install make rpmdevtools wget

or Docker.

# Building

    make rpm

or use Docker

    docker build -t kafka-build . && docker run -ti -v $(pwd)/RPMS:/root/RPMS kafka-build

Resulting RPM will be available at $(shell pwd)/RPMS/x86_64

# Installing and operating

    sudo yum install kafka*.rpm
    sudo systemctl start kafka
    sudo systemctl enable kafka

# Default locations

binaries: /opt/kafka  
data:     /var/lib/kafka  
logs:     /var/log/kafka  
configs:  /etc/kafka, /etc/sysconfig/kafka  

# kafka-graphite

Built from https://github.com/damienclaveau/kafka-graphite
