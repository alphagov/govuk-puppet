# == Class: collectd::plugin::docker
#
# Collectd plugin for docker
#
# === Parameters
#
# [*repo*]
# This variable is used to define the Github repository used to get the docker-collectd-plugin.
#
# [*commit*]
# This variable is used to set the commit has that we want to use. This will help us from drifting.
#
class collectd::plugin::docker(
  $repo = undef,
  $commit = undef,
) {
  include ::collectd

  $dependencies = [
    'py-dateutil<=2.2',
  ]

  package { $dependencies:
    ensure   => 'present',
    provider => 'pip',
    notify   => Class['collectd::service'],
  }

  # This has to be installed via exec rather than a package as the namespace
  # conflicts with the different (but same name) docker package. This issue
  # seems to be fixed in puppet 4: https://tickets.puppetlabs.com/browse/PUP-1073
  exec { 'pip install docker':
    path    => ['/usr/local/bin', '/usr/bin', '/bin'],
    command => 'pip install "docker<=2.6.1"',
    notify  => Class['collectd::service'],
  }

  package { 'docker-py':
    ensure   => 'absent',
    provider => 'pip',
  }

  vcsrepo { '/usr/share/collectd/docker-collectd-plugin':
    ensure   => present,
    provider => git,
    source   => $repo,
    revision => $commit,
    notify   => Class['collectd::service'],
    force    => true,
  }

  @collectd::plugin { 'docker':
    content => template('collectd/etc/collectd/conf.d/docker.conf.erb'),
    require => Package[$dependencies],
  }
}
