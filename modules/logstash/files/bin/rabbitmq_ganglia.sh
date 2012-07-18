#!/bin/bash
RABBITCTL="/usr/sbin/rabbitmqctl"
GMETRIC="/usr/bin/gmetric"
RABBIT_MESSAGES=`$RABBITCTL -q list_queues messages`
RABBIT_CONSUMERS=`$RABBITCTL -q list_queues consumers`
$GMETRIC -n "rabbitmq.messages" -v $RABBIT_MESSAGES -t int32 -x 120
$GMETRIC -n "rabbitmq.consumers" -v $RABBIT_CONSUMERS -t int32 -x 120
