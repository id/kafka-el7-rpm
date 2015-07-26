kafka-redhat7-rpm
---------
A set of scripts to package kafka into an rpm
Requires CentOS/RedHat 7.

Setup
-----
    sudo yum install make rpmdevtools

Building
--------
    make rpm

Resulting RPM will be avaliable at $(shell pwd)/x86_64

Installing and operating
------------------------
    sudo yum install kafka*.rpm
    sudo systemctl start kafka
    sudo systemctl enable kafka

Default locations
-----------------
binaries: /opt/kafka  
data:     /var/lib/kafka  
logs:     /var/log/kafka  
configs:  /etc/kafka, /etc/sysconfig/kafka  

kafka-graphite
--------------
Built from https://github.com/damienclaveau/kafka-graphite
