#!/bin/sh
PATH="/sbin:/bin:/usr/sbin:/usr/bin:/usr/games:/usr/local/sbin:/usr/local/bin"
export PATH

# Usage: mpd-linkup.sh interface
#[ -z "$1" ] && exit 1

# delete ipv4 gateway
# route delete default
# delete ipv6 gateway
route delete -inet6 default

# Add ipv4 gateway
#route add default -interface $1
# Add ipv6 gateway
route add -inet6 default -interface $1
#route -n add -inet6 default -iface ng0

# Restart dhcp6c (to get new ipv6 block from ISP)
/usr/sbin/service dhcp6c onerestart
