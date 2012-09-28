#!/bin/bash
if[ -f /etc/init.d/haproxy ]; then
  ps aux | grep "/usr/sbin/haproxy" | grep -v grep | awk ' { print $2 } ' | xargs kill
  /bin/rm -f /etc/init.d/haproxy
  /usr/sbin/update-rc.d haproxy remove
fi