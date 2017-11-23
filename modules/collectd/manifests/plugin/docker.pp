# == Class: collectd::plugin::docker
#
# Collectd plugin for docker
#
class collectd::plugin::docker {

  $dependencies = [
    'py-dateutil',
  ]

  package { $dependencies:
    ensure   => 'present',
    provider => 'pip',
  }

  # This has to be installed via exec rather than a package as the namespace
  # conflicts with the different (but same name) docker package. This issue
  # seems to be fixed in puppet 4: https://tickets.puppetlabs.com/browse/PUP-1073
  exec { 'pip install docker':
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    command => 'pip install docker',
  }

  package { 'docker-py':
    ensure   => 'absent',
    provider => 'pip',
  }

  @collectd::plugin { 'docker':
    content => template('collectd/etc/collectd/conf.d/docker.conf.erb'),
    require => Package[$dependencies],
  }
}
