# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq::monitoring {
  @@icinga::check { "check_rabbitmq_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!rabbitmq-server',
    service_description => 'rabbitmq-server not running',
    host_name           => $::fqdn,
  }
}
