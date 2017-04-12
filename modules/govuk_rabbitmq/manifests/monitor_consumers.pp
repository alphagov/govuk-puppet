# = govuk_rabbitmq::monitor_consumers
#
# Monitor for non-idle consumers on a rabbitmq queue
#
# [*rabbitmq_queue*]
# The queue to monitor
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
define govuk_rabbitmq::monitor_consumers (
  $rabbitmq_queue,
  $ensure = present,
  $rabbitmq_hostname = 'rabbitmq-1.backend',
  $rabbitmq_user = 'monitoring',
  $rabbitmq_admin_port = 15672,
){

  if $ensure == present {
    include icinga::plugin::check_rabbitmq_consumers

    @@icinga::check { "check_rabbitmq_consumers_for_${rabbitmq_queue}_on_${::hostname}":
      check_command       => "check_nrpe!check_rabbitmq_consumers!${rabbitmq_hostname} ${rabbitmq_admin_port} ${rabbitmq_queue} ${rabbitmq_user}",
      service_description => "Check that there is at least one non-idle consumer for rabbitmq queue ${rabbitmq_queue}",
      host_name           => $::fqdn,
      notes_url           => monitoring_docs_url(rabbitmq-no-consumers-listening),
    }
  }
}
