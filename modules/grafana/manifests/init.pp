# == Class: grafana
#
# Set up grafana.
#
class grafana {
  include grafana::repo
  include grafana::dashboards

  package { 'grafana':
    ensure => latest,
  }

  file { '/etc/grafana':
    ensure => directory,
  }

  file { '/etc/grafana/config.js':
    ensure => absent,
  }

  file { '/etc/grafana/grafana.ini':
    ensure => file,
    source => 'puppet:///modules/grafana/grafana.ini',
  }

  nginx::config::site { 'grafana':
    source => 'puppet:///modules/grafana/vhost.conf',
  }
}
