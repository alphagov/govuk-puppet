#!/bin/bash

/usr/sbin/service stop nginx
/usr/sbin/service stop haproxy
set -e
/bin/rm -f /etc/init.d/nginx
/bin/rm -f /etc/init.d/haproxy
/usr/sbin/update-rc.d nginx remove
/usr/sbin/update-rc.d haproxy remove