#!/bin/bash
RABBITCTL="/usr/sbin/rabbitmqctl"
GMETRIC="/usr/bin/gmetric"
RABBIT_MESSAGES=`$RABBITCTL -q list_queues messages`
$GMETRIC -n "rabbitmq.messages" -v $RABBIT_MESSAGES -t int32 -x 120