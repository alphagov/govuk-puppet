# = govuk_rabbitmq::monitor_messages
#
# Monitor for unprocessed messages on a rabbitmq queue
#
# [*rabbitmq_queue*]
# The queue to monitor
#
# [*critical_threshold*]
#   The threshold for a critical alert
#
# [*warning_threshold*]
#   The threshold for a warning alert
#
# [*ensure*]
#   Whether the monitoring should be created
#
# [*rabbitmq_hostname*]
# The hostname of a server in the rabbitmq cluster
# Default: rabbitmq-1.backend
#
# [*rabbitmq_user*]
# The user to connect as when monitoring, the password will be passed from
# Hiera as icinga::plugin::check_rabbitmq_consumers::monitoring_password
# Default: monitoring
#
# [*rabbitmq_admin_port*]
# The admin port of the rabbitmq server
# Default: 15672
define govuk_rabbitmq::monitor_messages (
  $rabbitmq_queue,
  $critical_threshold,
  $warning_threshold,
  $ensure = present,
  $rabbitmq_hostname = 'rabbitmq-1.backend',
  $rabbitmq_user = 'monitoring',
  $rabbitmq_admin_port = 15672,
){

  if $ensure == present {
    include icinga::plugin::check_rabbitmq_messages

    @@icinga::check { "check_rabbitmq_messages_for_${rabbitmq_queue}_on_${::hostname}":
      check_command       => "check_nrpe!check_rabbitmq_messages!${rabbitmq_hostname} ${rabbitmq_admin_port} ${rabbitmq_queue} ${rabbitmq_user} ${critical_threshold} ${warning_threshold}",
      service_description => "Check that messages are being processed in rabbitmq queue ${rabbitmq_queue}",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(rabbitmq-no-consumers-consuming),
    }
  }
}
