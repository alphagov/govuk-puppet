#!/bin/bash

/usr/sbin/service stop nginx
/usr/sbin/service stop haproxy
rm -f /etc/init.d/nginx
rm -f /etc/init.d/haproxy
exit 0