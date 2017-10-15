# == Class: collectd::plugin::docker
#
# Collectd plugin for docker
#
class collectd::plugin::docker {

  $dependencies = [
    'py-dateutil',
    'docker-py',
  ]

  package { $dependencies:
    ensure   => 'present',
    provider => 'pip',
  }

  @collectd::plugin { 'docker':
    content => template('collectd/etc/collectd/conf.d/docker.conf.erb'),
    require => Package[$dependencies],
  }
}
