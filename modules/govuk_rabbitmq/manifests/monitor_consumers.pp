# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
define govuk_rabbitmq::monitor_consumers (
  $rabbitmq_queue,
  $rabbitmq_hostname = 'rabbitmq-1',
  $rabbitmq_user = 'monitoring',
  $rabbitmq_port = 15672,
){

  include icinga::plugin::check_rabbitmq_consumers

  @@icinga::check { "check_rabbitmq_consumers_for_${rabbitmq_queue}_on_${::hostname}":
    check_command       => "check_nrpe!check_rabbitmq_consumers!${rabbitmq_hostname} ${rabbitmq_port} ${rabbitmq_queue} ${rabbitmq_user}",
    service_description => "Check that there is at least one non-idle consumer for rabbitmq queue ${rabbitmq_queue}",
    host_name           => $::fqdn,
  }
}
