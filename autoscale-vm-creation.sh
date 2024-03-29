#!/bin/bash
# CentOS 7.4
sudo sed -i "17i Port 2266" /etc/ssh/sshd_config
sudo mkdir /tmp/serverconfig
sudo echo "127.0.0.1      nomadx.sg" >>/etc/hosts
sudo mount -t nfs -o,rw 10.0.0.11:/home/atadmin/server-configuration/magento/nomadx/PROD  /tmp/serverconfig
sudo cp -var /tmp/serverconfig/etc/* /etc/
sudo chown -R root:root /etc/nginx /etc/php-fpm.d /etc/php.ini /etc/postfix
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
sudo rm -rf /tmp/serverconfig
sudo chown -R root:root /etc/postfix
sudo chmod 600 /etc/postfix/sasl*
sudo chown -R atadmin:nginx /var/log/nginx
sudo chmod -R 2754 /var/log/nginx
sudo usermod -a -G atadmin nginx
sudo systemctl disable newrelic-infra.service
sudo systemctl stop newrelic-infra.service
sudo echo "/usr/bin/mount -t nfs -o,rw 10.0.0.11:/opt/nomadx /opt/nomadx" >>/etc/rc.local
sudo umount -l /opt/nomadx
sudo chmod +x /etc/rc.d/rc.local
sudo systemctl enable rc-local
sudo systemctl restart rc-local
sudo shutdown -r now
##Nginx Amplify Agent
sudo curl -L -O https://github.com/nginxinc/nginx-amplify-agent/raw/master/packages/install.sh
sudo API_KEY='437c63189b7617ed2ae39724805bfd4b' sh ./install.sh
sudo systemctl restart nginx
