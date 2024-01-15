#!/bin/sh
echo "Boostrapping started ..."
wg-quick up /etc/wireguard/wg0.conf &
./app/wgrest --listen '0.0.0.0:8080'
echo "Shutting Down ..."


