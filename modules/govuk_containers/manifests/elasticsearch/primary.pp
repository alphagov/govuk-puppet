# == Class: govuk_containers::elasticsearch::primary
#
# Install and run a dockerised Elasticsearch server
#
# === Parameters
#
# [*version*]
#   The docker image version to use.
#
# [*port*]
#   The port (outside the container) to use for elasticsearch.
#
class govuk_containers::elasticsearch::primary(
  $version = '5.6.15',
  $port    = '9200',
  $ensure  = 'present',
) {
  # todo: remove absent things
  ::docker::run { 'elasticsearch':
    ensure => 'absent',
    image  => "elasticsearch:${version}",
  }

  ::govuk_containers::elasticsearch { 'primary':
    ensure             => $ensure,
    image_version      => $version,
    elasticsearch_port => $port,
  }

  @icinga::nrpe_config { 'check_dockerised_elasticsearch_responding':
    ensure => 'absent',
    source => 'puppet:///modules/govuk_containers/nrpe_check_dockerised_elasticsearch_responding.cfg',
  }

  @@icinga::check { "check_dockerised_elasticsearch_responding_${::hostname}":
    ensure              => 'absent',
    check_command       => "check_nrpe!check_dockerised_elasticsearch_responding!${port}",
    service_description => 'dockerised elasticsearch port not responding',
    host_name           => $::fqdn,
  }
}
