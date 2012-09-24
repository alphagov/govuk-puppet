#! /bin/bash

# This script takes two arguments, the class of the machine and the application name, and calculates a running
# value of the apdex across all instances of the application. Apdex is a measure of an applications performance
# based on response time. Currently it logs the output into /var/log/apdex
# example usage: ./apdex.sh frontend calendars

CLASS=$1
APPLICATION=$2

echo "`date`, `cat /var/log/logstash-aggregation/${CLASS}-*/var/log/nginx/${APPLICATION}.*-access.log | grep -v 408 | awk -F' ' '{print $(NF-3)}' | apdex_from_log --threshold 1 | grep 'Score' | awk -F' ' '{print $(NF)}'`" >> /var/log/apdex/${APPLICATION}.log
