#! /bin/bash
cd client 
useradd -M -U -s /sbin/nologin openvpn
rm -rf /etc/openvpn
mkdir -p /etc/openvpn
mkdir -p /etc/openvpn/certs
cp * /etc/openvpn
cp certs/* /etc/openvpn/certs

sysctl -w net.ipv4.ip_forward=1
# restorecon -Rv /etc/openvpn
#ln -s /lib/systemd/system/openvpn@.service /etc/systemd/system/openvpn@client.service
# service openvpnclient start
cd ..
