#!/bin/sh
echo "starting wgrest..."
./app/wgrest --listen '127.0.0.1:51800' &

stop () {
    echo "stopping wg0 ..."
    wg-quick down wg0
    exit 0
}
trap stop SIGTERM SIGINT SIGQUIT

echo "starting wg0 ..."
wg-quick up /etc/wireguard/wg0.conf
# echo "Public key '$(cat /etc/wireguard/privatekey | wg pubkey)'"
sleep infinity &
wait $!

