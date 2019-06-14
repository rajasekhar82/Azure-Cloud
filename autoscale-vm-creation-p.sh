#!/bin/bash
# CentOS 7.6
sudo yum install mod_ssl -y
sudo rm -rf /etc/httpd/conf.d/ssl.conf
sudo sed -i "17i Port 22" /etc/ssh/sshd_config
sudo sed -i "21i Port 2266" /etc/ssh/sshd_config
sudo mkdir /tmp/serverconfig
sudo umount /tmp/serverconfig
sudo umount /var/www/v2/gpuma
sudo echo "127.0.0.1      in.puma.com" >>/etc/hosts
sudo mount -t nfs -o,rw 10.0.0.7:/home/atadmin/server-configuration/PROD /tmp/serverconfig
sudo cp -var /tmp/serverconfig/etc/* /etc/
sudo chown -R root:root /etc/nginx /etc/php-fpm.d /etc/php.ini /etc/postfix /etc/httpd
sudo mount -t nfs -o,rw 10.0.0.7:/opt/puma /var/www/v2/gpuma
sudo chown -R atadmin:atadmin /var/lib/php/*
sudo systemctl enable httpd
sudo systemctl start httpd
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
sudo timedatectl set-timezone Asia/Kolkata
sudo systemctl restart rsyslog
sudo systemctl enable crond
sudo systemctl start crond
sudo cd /home/atadmin
sudo umount -l /tmp/serverconfig
sudo rm -rf /tmp/serverconfig
sudo chown -R root:root /etc/postfix
sudo chmod 600 /etc/postfix/sasl*
sudo chown -R atadmin:nginx /var/log/nginx
sudo chmod -R 2754 /var/log/nginx
sudo usermod -a -G atadmin nginx
sudo systemctl disable newrelic-infra.service
sudo systemctl stop newrelic-infra.service
sudo echo "/usr/bin/mount -t nfs -o,rw 10.0.0.7:/opt/puma  /var/www/v2/gpuma" >>/etc/rc.local
sudo umount -l /var/www/v2/gpuma
sudo chmod +x /etc/rc.d/rc.local
sudo systemctl enable rc-local
sudo systemctl restart rc-local
sudo shutdown -r now
