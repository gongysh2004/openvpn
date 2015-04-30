vim var
. var
./build-ca
./build-key-server openvpnserver
./build-key --batch openvpnclient1
./build-ha
openvpn --genkey --secret ta.key
