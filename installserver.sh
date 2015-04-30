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
cd ..
# restorecon -Rv /etc/openvpn
