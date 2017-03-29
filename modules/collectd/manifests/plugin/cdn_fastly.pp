# == Class: collectd::plugin::cdn_fastly
#
# Fetch stats from Fastly's API.
#
# === Parameters
#
# [*username*]
#   Fastly username.
#
# [*password*]
#   Fastly password.
#
# [*services*]
#   A hash of services. In the format:
#   `{ 'friendly_name' => 'service_id', }`
#
class collectd::plugin::cdn_fastly (
  $username,
  $password,
  $services,
) {
  include collectd::plugin::python

  validate_hash($services)

  package { 'collectd-cdn':
    ensure   => '0.2.1',
    provider => 'pip',
  }

  collectd::plugin { 'cdn_fastly':
    content => template('collectd/etc/collectd/conf.d/cdn_fastly.conf.erb'),
    require => [
      Class['collectd::plugin::python'],
      Package['collectd-cdn']
    ],
  }
}
