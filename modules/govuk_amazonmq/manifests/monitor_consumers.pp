# = govuk_amazonmq::monitor_consumers
#
# Monitor for number of consumers on an AmazonMQ queue, averaged over a given number of minutes.
#
# [*queue_name*]
# The queue to monitor
#
# [*broker_name*]
# Name of the AmazonMQ broker
#
# [*virtual_host*]
# Virtual host name under which the queue sits [Defaults to 'publishing']
#
# [*region*]
# The AWS region in which Cloudwatch resides [Defaults to 'eu-west-1']
#
# [*critical_threshold*]
# The threshold at which this check will show as CRITICAL. See https://www.monitoring-plugins.org/doc/guidelines.html#THRESHOLDFORMAT
# [Defaults to '1:' ie. any less than 1]
#
# [*warning_threshold*]
# The threshold at which this check will show as WARNING. See https://www.monitoring-plugins.org/doc/guidelines.html#THRESHOLDFORMAT
# [Defaults to '2:' ie. any less than 2]
#
# [*minutes*]
# The time window over which the count will be averaged. [Defaults to 5]
#
# [*ensure*]
#   Whether the monitoring should be created
#
define govuk_amazonmq::monitor_consumers (
  $queue_name,
  $broker_name = 'PublishingMQ',
  $virtual_host = 'publishing',
  $region = 'eu-west-1',
  $critical_threshold = '1:',
  $warning_threshold = '2:',
  $minutes = 5,
  $ensure = present,
){

  if $ensure == present {
    icinga::check { "check_amazonmq_consumers_for_${queue_name}_on_${::hostname}":
      check_command       => "check_amazonmq_consumers!${broker_name}!${virtual_host}!${queue_name}!${region}!${critical_threshold}!${warning_threshold}!${minutes}",
      service_description => "Consumer count ${minutes} min avg for AmazonMQ:${broker_name}/${virtual_host}/${queue_name}",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
    }
  }
}
