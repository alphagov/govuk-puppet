# = govuk_amazonmq::monitor_consumers
#
# Monitor for non-idle consumers on a amazonmq queue
#
# [*amazonmq_queue*]
# The queue to monitor
#
# [*ensure*]
#   Whether the monitoring should be created
#
define govuk_amazonmq::monitor_consumers (
  $broker_name,
  $virtual_host,
  $queue_name,
  $region = 'eu-west-1',
  $critical_threshold = '1:',
  $warning_threshold = '2:',
  $minutes = 5,
  $ensure = present,
){

  if $ensure == present {
    icinga::check { "check_amazonmq_consumers_for_${queue_name}_on_${::hostname}":
      check_command       => "check_amazonmq_consumers!${broker_name}!${virtual_host}!${queue_name}!${region}!${critical_threshold}!${warning_threshold}!${minutes}",
      service_description => "Consumer count over ${minutes}m for AmazonMQ:${broker_name}/${virtual_host}/${queue_name}",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(amazonmq-no-consumers-listening),
    }
  }
}
