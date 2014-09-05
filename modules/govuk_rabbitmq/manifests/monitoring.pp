# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq::monitoring {

  include icinga::plugin::check_http_timeout_noncrit

  @icinga::nrpe_config { 'check_rabbitmq_network_partition':
    content => template('govuk_rabbitmq/check_rabbitmq_network_partition.cfg.erb'),
    require             => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  @@icinga::check { "check_rabbitmq_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!rabbitmq-server',
    service_description => 'rabbitmq-server not running',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_rabbitmq_network_partitions_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_rabbitmq_network_partition',
    service_description => 'RabbitMQ network partition has occurred',
    host_name           => $::fqdn,
  }
}
