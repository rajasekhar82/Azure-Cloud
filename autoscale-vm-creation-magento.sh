#!/bin/bash
# CentOS 7.4
sudo sed -i "17i Port 2266" /etc/ssh/sshd_config
sudo mkdir /tmp/serverconfig
echo "127.0.0.1      nomadxuat.aceturtle.in" |sudo tee -a /etc/hosts
sudo mkdir -p /opt/nomadx/pub
sudo mkdir -p /opt/nomadx/var/log
sudo mkdir /tmp/nomadx
sudo mount -t nfs -o,rw,10.0.0.7:/opt/nomadx  /tmp/nomadx
sudo rsync -avz --exclude="pub" --exclude="log" --exclude="var/cache" --exclude="generated" /tmp/nomadx/*   /opt/nomadx/
sudo mount -t nfs -o,rw 10.0.0.7:/home/atadmin/server-configuration/UAT  /tmp/serverconfig
sudo mount -t nfs -o,rw 10.0.0.7:/opt/nomadx/pub /opt/nomadx/pub
sudo mount -t nfs -o,rw 10.0.0.7:/opt/nomadx/var/log /opt/nomadx/var/log
sudo cp -var /tmp/serverconfig/etc/* /etc/
sudo chown -R root:root /etc/nginx /etc/php-fpm.d /etc/php.ini /etc/postfix
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
sudo echo "/usr/bin/mount -t nfs -o,rw 10.0.0.7:/opt/nomadx/pub /opt/nomadx/pub" >>/etc/rc.local
sudo echo "/usr/bin/mount -t nfs -o,rw 10.0.0.7:/opt/nomadx/var/log /opt/nomadx/var/log" >>/etc/rc.local
sudo umount -l /opt/nomadx/pub
sudo umount -l /opt/nomadx/log
sudo chmod +x /etc/rc.d/rc.local
sudo systemctl enable rc-local
sudo systemctl restart rc-local
sudo shutdown -r now
##Nginx Amplify Agent
sudo curl -L -O https://github.com/nginxinc/nginx-amplify-agent/raw/master/packages/install.sh
sudo API_KEY='437c63189b7617ed2ae39724805bfd4b' sh ./install.sh
sudo systemctl restart nginx
