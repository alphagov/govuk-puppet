# == Class: collectd::config
#
# Sets up collectd configuration.
#
class collectd::config {
  file { '/etc/collectd/collectd.conf':
    ensure  => present,
    content => template('collectd/etc/collectd/collectd.conf.erb'),
  }

  file { '/etc/collectd/types.conf':
    ensure => present,
    source => 'puppet:///modules/collectd/etc/collectd/types.conf',
  }

  file { '/etc/collectd/conf.d':
    ensure  => directory,
    purge   => true,
    recurse => true,
  }

  # types are needed by both server and client, so can't live in plugin classes
  # See https://collectd.org/documentation/manpages/types.db.5.shtml
  file { '/usr/share/collectd/types.db.rabbitmq':
    ensure => present,
    source => 'puppet:///modules/collectd/usr/share/collectd/types.db.rabbitmq',
  }

  file { '/etc/collectd/conf.d/default.conf':
    ensure => present,
    source => 'puppet:///modules/collectd/etc/collectd/conf.d/default.conf',
  }

  if $::aws_migration {
    $graphite_hostname = 'graphite'

    file { '/etc/collectd/conf.d/graphite.conf':
      ensure => present,
      source => template('collectd/etc/collectd/conf.d/graphite.conf.erb'),
    }
  } else {
    $graphite_hostname = 'graphite.cluster'

    file { '/etc/collectd/conf.d/network.conf':
      ensure  => present,
      content => template('collectd/etc/collectd/conf.d/network.conf.client.erb'),
    }
  }

  include ::collectd::plugin::file_handles
  # Always collect basic processlist info.
  include ::collectd::plugin::processes
  include ::collectd::plugin::tcpconns
}
