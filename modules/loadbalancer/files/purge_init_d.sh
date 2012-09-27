#!/bin/bash

/sbin/service stop nginx
/sbin/service stop haproxy
set -e
/bin/rm -f /etc/init.d/nginx
/bin/rm -f /etc/init.d/haproxy
exit 0