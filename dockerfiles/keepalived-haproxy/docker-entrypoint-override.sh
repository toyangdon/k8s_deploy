#!/bin/sh
set -e

# exec haproxy entry poing script
exec /docker-entrypoint.sh "$@" &

# start keepalived
exec /usr/sbin/keepalived --dont-fork --dump-conf --log-console --log-detail --log-facility 7 --vrrp -f /etc/keepalived/keepalived.conf