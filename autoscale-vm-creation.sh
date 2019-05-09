#!/bin/bash
# CentOS 7.4

sudo mkdir /tmp/serverconfig
sudo mount -t nfs -o,rw 10.0.0.7:/home/atadmin/server-configuration/UAT /tmp/serverconfig
sudo cp -var /tmp/serverconfig/UAT/etc/* /etc/
sudo chmod -R root:root /etc/nginx /etc/php-fpm.d /etc/php.ini
sudo mount -t nfs -o,rw 10.0.0.7:/opt/nomadx /opt/nomadx
sudo chown -R atadmin:atadmin /var/lib/php/*
sudo systemctl enable nginx 
sudo systemctl restart nginx
sudo systemctl enable php-fpm
sudo systemctl restart php-fpm
sudo systemctl enable postfix
sudo systemctl restart postfix
sudo systemctl stop firewalld
sudo systemctl stop tuned
sudo systemctl disable firewalld
sudo systemctl disable tuned
sudo timedatectl set-timezone  Asia/Singapore
sudo systemctl restart rsyslog
sudo systemctl enable crond
sudo systemctl start crond
sudo cd /home/atadmin
sudo rm -rf /tmp/serverconfig
shutdown -r now
