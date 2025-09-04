#!/bin/sh
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
export PATH

# Usage: mpd-linkup.sh interface
#[ -z "$1" ] && exit 1

#route delete default
#route delete -inet6 default
#route add default -interface $1
#route add -inet6 default -interface $1
#route -n add -inet6 default -iface ng0

# Stop dhcp6c
/usr/sbin/service dhcp6c onestop
