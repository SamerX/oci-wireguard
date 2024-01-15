#!/bin/sh
echo "boostrapping started ..."
wg-quick up /etc/wireguard/wg0.conf &
./app/wgrest
echo "bootstrapping finished ..."


