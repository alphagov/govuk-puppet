# == Class: collectd::plugin::cdn_fastly
#
# Fetch stats from Fastly's API.
#
# === Parameters
#
# [*api_key*]
#   Fastly API key.
#   FIXME: Replace with user/pass.
#
# [*services*]
#   A hash of services. In the format:
#   `{ 'friendly_name' => 'service_id', }`
#
class collectd::plugin::cdn_fastly(
  $api_key,
  $services,
) {
  include collectd::plugin::python

  validate_hash($services)

  package { 'collectd-cdn':
    ensure   => '0.1.0',
    provider => 'pip',
  }

  # FIXME: Remove.
  file { '/usr/lib/collectd/python/cdn_fastly.py':
    ensure  => absent,
  }

  collectd::plugin { 'cdn_fastly':
    content => template('collectd/etc/collectd/conf.d/cdn_fastly.conf.erb'),
    require => [
      Class['collectd::plugin::python'],
      Package['collectd-cdn']
    ],
  }
}
