#!/bin/bash
if /etc/init.d/nginx status | grep -v running; then
  /usr/bin/logger "loadbalancer::Stopping haproxy because nginx is down"
  /etc/init.d/haproxy stop
  
 if [[ $? != "0" ]] ; then
  /usr/bin/logger "Failed to Stop"
 else
  /usr/bin/logger "loadbalancer::Stopped successfully"
 fi
fi
