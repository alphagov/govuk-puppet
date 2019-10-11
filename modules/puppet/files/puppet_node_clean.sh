#!/bin/bash

export AWS_DEFAULT_REGION=$(facter -p aws_region)
if [[ -z $AWS_DEFAULT_REGION ]] ; then
  echo "Error: aws_region is null"
  exit
fi

STACKNAME=$(facter -p aws_stackname)
if [[ -z ${STACKNAME} ]] ; then
  echo "Error: stackname is null"
  exit
fi

# Do we need "Name=tag:puppet_cert_signed,Values=*" ?
awk 'FNR==NR{ array[$0];next}
{ if ( $1 in array ) next
print $1}
' <(aws ec2 describe-instances --filters "Name=tag:aws_stackname,Values=${STACKNAME}" "Name=instance-state-name,Values=pending,running,shutting-down,stopping,stopped" --output=json | jq -r '.Reservations[] | .Instances[] | .InstanceId ') <(curl 'http://localhost:8080/v3/nodes' 2>/dev/null | grep name | awk '{print $3}' | tr -d '",') | while read NODE
do
  echo "[$(date '+%H:%M:%S %d-%m-%Y')] Preparing to delete: ${NODE}:"
  curl "http://localhost:8080/v3/nodes/${NODE}/facts/aws_migration"
  echo
  puppet node clean "${NODE}"
  puppet node deactivate "${NODE}"
done

