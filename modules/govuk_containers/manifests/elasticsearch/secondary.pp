# == Class: govuk_containers::elasticsearch::secondary
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
class govuk_containers::elasticsearch::secondary(
  $version = '6.7.2',
  $port    = '9201',
  $ensure  = 'present',
  $enable  = true,
) {
  if $enable {
    ::govuk_containers::elasticsearch { 'secondary':
      ensure             => $ensure,
      image_version      => $version,
      elasticsearch_port => $port,
    }
  }
}
