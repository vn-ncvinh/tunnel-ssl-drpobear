#! /bin/bash
#
# Coded by NCV
#
# Email: vn.ncvinh@gmail.com
#
# Auto installer script for tunnel, dropbear
#
# Tested on Ubuntu 18.04

clear
cd /tmp
echo "- Dang cap nhat tai nguyen..."
apt-get update  > /dev/null 2>&1
printf "\033c"
echo "- Install Process Starting"
echo "--------------------------------"

echo "- Enable PermitRootLogin and PasswordAuthentication"
sed -i 's/#PermitRootLogin prohibit\-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PermitRootLogin without\-password/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/#PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config

echo "- Install Dropbear, Stunnel and ssh service"
apt-get -y install dropbear stunnel4 > /dev/null 2>&1
cd /etc/stunnel/ && wget -N https://raw.githubusercontent.com/vn-ncvinh/tunnel-ssl-drpobear/main/file/stunnel.conf > /dev/null 2>&1
sed -i 's/http/\#http/g' /etc/services > /dev/null 2>&1
sed -i 's/https/\#https/g' /etc/services > /dev/null 2>&1
sed -i 's/\*.conf/stunnel.conf/g' /etc/default/stunnel4 > /dev/null 2>&1
sed -i 's/ENABLED\=0/ENABLED\=1/g' /etc/default/stunnel4 > /dev/null 2>&1

#Config Dropbear with port 80 and enable banner
sed -i 's/NO_START\=1/NO_START\=0/g' /etc/default/dropbear > /dev/null 2>&1
sed -i 's/DROPBEAR_PORT\=22/DROPBEAR_PORT\=80/g' /etc/default/dropbear > /dev/null 2>&1
sed -i 's/DROPBEAR_BANNER\=/DROPBEAR_BANNER\=\"\/etc\/bannerncv"/g' /etc/default/dropbear > /dev/null 2>&1

echo "Pre-Login banner"
cd /etc/ && wget -N https://raw.githubusercontent.com/vn-ncvinh/tunnel-ssl-drpobear/main/file/bannerncv > /dev/null 2>&1

echo "tls/ssl"
cd /etc/stunnel/ && wget -N https://raw.githubusercontent.com/vn-ncvinh/tunnel-ssl-drpobear/main/file/stunnel.pem > /dev/null 2>&1
# openssl genrsa -out key.pem 2048 > /dev/null 2>&1
# openssl req -new -x509 -key key.pem -out cert.pem -days 1095 
# cat key.pem cert.pem >> /etc/stunnel/stunnel.pem 

/etc/init.d/dropbear restart
/etc/init.d/stunnel4 restart
sudo systemctl enable dropbear.service
sudo systemctl enable stunnel4.service
service sshd restart

printf "\033c"
echo "Congratulations, Finished All!"
echo "Dropbear is running on port: 80"
echo "SSL Dropbear is running on port: 443"
echo ""
echo "Khoi dong lai server..."
echo ""
sleep 3 ; reboot
