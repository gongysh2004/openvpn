#! /bin/bash
cd server
useradd -M -U -s /sbin/nologin openvpn
mkdir -p /etc/openvpn
mkdir -p /etc/openvpn/certs
mkdir -p /etc/openvpn/clients
cp * /etc/openvpn
cp clients/* /etc/openvpn/clients
cp certs/* /etc/openvpn/certs

sysctl -w net.ipv4.ip_forward=1
# echo 'net.ipv4.ip_forward=1' >> /etc/sysctl.conf
# yum install iptables-services
# touch /etc/sysconfig/iptables
# touch /etc/sysconfig/ip6tables
# systemctl start iptables
# systemctl start ip6tables
# systemctl enable iptables
# systemctl enable ip6tables
# iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE
cd ..
# restorecon -Rv /etc/openvpn
