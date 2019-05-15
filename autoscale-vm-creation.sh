#!/bin/bash
# CentOS 7.4
sudo mkdir /tmp/serverconfig
sudo echo "127.0.0.1      nomadxprod.aceturtle.in" >>/etc/hosts
sudo mount -t nfs -o,rw 10.0.0.11:/home/atadmin/server-configuration/UAT /tmp/serverconfig
sudo cp -var /tmp/serverconfig/etc/* /etc/
sudo chmod -R root:root /etc/nginx /etc/php-fpm.d /etc/php.ini
sudo mount -t nfs -o,rw 10.0.0.11:/opt/nomadx /opt/nomadx
sudo chown -R atadmin:atadmin /var/lib/php/*
sudo systemctl disable httpd
sudo systemctl stop httpd
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
sudo umount -l /tmp/serverconfig
sudo chown -R root:root /etc/postfix
sudo chmod 600 /etc/postfix/sasl*