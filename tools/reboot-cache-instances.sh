#!/usr/bin/env bash

set -eu

OPTIND=1 # Reset in case getopts has been used previously in the shell.

function show_help {
  echo "Usage: gds aws govuk-integration-poweruser $0 -e integration ip-1-2-3-4.eu-west-1.compute.internal"
  exit 64
}

govuk_env=""

while getopts :e:h opt; do
    case $opt in
      h) show_help;;
      e) govuk_env=${OPTARG};;
    esac
done

shift $((OPTIND-1))
[ "${1:-}" = "--" ] && shift
instance_private_dns_name=$*

if [ -z "${govuk_env}" ]
then
  echo "[Error] You must provide an environment"
  show_help
fi
if [ -z "${instance_private_dns_name}" ]
then
  echo "[Error] You must provide an instance_private_dns_name like ip-1-2-3-4.eu-west-1.compute.internal"
  show_help
fi

echo "Going to reboot $instance_private_dns_name in $govuk_env"

instance_id=$(aws ec2 describe-instances \
  --filters "Name=private-dns-name,Values=$instance_private_dns_name" \
  | jq -r .Reservations[0].Instances[0].InstanceId)

echo "It has instance_id $instance_id"

asg_name=$(aws autoscaling describe-auto-scaling-instances --instance-ids "$instance_id" | jq .AutoScalingInstances[0].AutoScalingGroupName -r)

aws autoscaling enter-standby --instance-ids "$instance_id" \
  --auto-scaling-group-name "$asg_name" --should-decrement-desired-capacity

function instanceState {
  aws autoscaling describe-auto-scaling-instances --instance-ids "$instance_id" | jq .AutoScalingInstances[0].LifecycleState -r
}

until [ "$(instanceState)" == "Standby" ]
do
  echo "Waiting for instance to be in Standby state (currently $(instanceState))"
  sleep 3
done

echo "Waiting for requests to complete... 30 seconds"
sleep 30

echo "Rebooting instance via ssh"
gds govuk connect ssh -e "$govuk_env" "$instance_private_dns_name" -- -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "sudo shutdown -r now"

echo "Rebooted, waiting for instance to come back up..."
sleep 10

aws ec2 wait instance-status-ok --instance-ids "$instance_id"

function appStatusCode {
  gds govuk connect ssh -e "$govuk_env" "$instance_private_dns_name" -- -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "curl -s -o /dev/null -w '%{http_code}' localhost:80/_healthcheck_www"
}

until [ "$(appStatusCode)" == "200" ]
do
  echo "Waiting for apps to be healthy..."
  sleep 5
done

echo "Putting instance back into service..."

aws autoscaling exit-standby --instance-ids "$instance_id" --auto-scaling-group-name "$asg_name"

until [ "$(instanceState)" == "InService" ]
do
  echo "Waiting for instance to enter service..."
  sleep 3
done

echo "Done!"
