#!/bin/sh
echo "boostrapping started ..."
#wg-quick up /etc/wireguard/wg0.conf &
./app/wgrest --listen '0.0.0.0:8080'
echo "bootstrapping finished ..."


