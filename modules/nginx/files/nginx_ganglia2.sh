#!/bin/bash
OUTPUT=`wget -qO- http://127.0.0.234/nginx_status`
validoutput=`echo $OUTPUT | grep -c "Active" 2>/dev/null`

if [ $validoutput -eq 1 ]; then
  nginx_status_available=1
  nginx_active_connections=`echo $OUTPUT | cut -d\  -f3`
  nginx_waiting=`echo $OUTPUT | cut -d\  -f16`
  nginx_writing=`echo $OUTPUT | cut -d\  -f14`
  nginx_reading=`echo $OUTPUT | cut -d\  -f12`
  nginx_requests=`echo $OUTPUT | cut -d\  -f10`
  nginx_accepts=`echo $OUTPUT | cut -d\  -f8`
  nginx_handled=`echo $OUTPUT | cut -d\  -f9`
else
  nginx_status_available=0
  nginx_active_connections=0
  nginx_waiting=0
  nginx_writing=0
  nginx_reading=0
  nginx_requests=0
  nginx_accepts=0
  nginx_handled=0
fi
/usr/bin/gmetric -n nginx_status_available -v ${nginx_status_available} -t int32
/usr/bin/gmetric -n nginx_active_connections -v ${nginx_active_connections} -t int32 -u Connections
/usr/bin/gmetric -n nginx_waiting -v ${nginx_waiting} -t int32 -u Connections
/usr/bin/gmetric -n nginx_writing -v ${nginx_writing} -t int32 -u Connections
/usr/bin/gmetric -n nginx_reading -v ${nginx_reading} -t int32 -u Connections
/usr/bin/gmetric -n nginx_requests -v ${nginx_requests} -t int32 -u Connections
/usr/bin/gmetric -n nginx_accepts -v ${nginx_accepts} -t int32 -u Connections
/usr/bin/gmetric -n nginx_handled -v ${nginx_handled} -t int32 -u Connections

