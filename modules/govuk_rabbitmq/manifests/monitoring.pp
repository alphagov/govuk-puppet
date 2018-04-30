# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk_rabbitmq::monitoring (
  $monitoring_user,
  $monitoring_password,
) {

  include icinga::plugin::check_http_timeout_noncrit
  include icinga::plugin::check_rabbitmq_watermark

  @icinga::nrpe_config { 'check_rabbitmq_network_partition':
    content => template('govuk_rabbitmq/check_rabbitmq_network_partition.cfg.erb'),
    require => Icinga::Plugin['check_http_timeout_noncrit'],
  }

  @@icinga::check { "check_rabbitmq_running_${::hostname}":
    check_command       => 'check_nrpe!check_proc_running!rabbitmq-server',
    service_description => 'rabbitmq-server not running',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(check-process-running),
  }

  @@icinga::check { "check_rabbitmq_network_partitions_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_rabbitmq_network_partition',
    service_description => 'RabbitMQ network partition has occurred',
    host_name           => $::fqdn,
  }

  @@icinga::check { "check_rabbitmq_watermark_${::hostname}":
    check_command       => 'check_nrpe_1arg!check_rabbitmq_watermark',
    service_description => 'RabbitMQ high watermark has been exceeded',
    host_name           => $::fqdn,
    notes_url           => monitoring_docs_url(rabbitmq-high-watermark),
  }
}
