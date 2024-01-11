#!/bin/sh
#echo "boostrapping started ..."
#wg-quick up /etc/wireguard/wg0.conf &
./app/wgrest --listen '127.0.0.1:8080'
#echo "bootstrapping finished ..."


