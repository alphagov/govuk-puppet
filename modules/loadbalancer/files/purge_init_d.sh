#!/bin/bash
if[ -f /etc/init.d/nginx ]; then
  ps aux | grep "nginx: master process" | grep -v grep | awk ' { print $2 } ' | xargs kill
   /bin/rm -f /etc/init.d/nginx
   /usr/sbin/update-rc.d nginx remove
fi

if[ -f /etc/init.d/nginx ]; then
  ps aux | grep "/usr/sbin/haproxy" | grep -v grep | awk ' { print $2 } ' | xargs kill
  /bin/rm -f /etc/init.d/haproxy
  /usr/sbin/update-rc.d haproxy remove
fi