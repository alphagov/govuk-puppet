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
    ensure => file,
    source => 'puppet:///modules/grafana/config.js',
  }

  nginx::config::site { 'grafana':
    source => 'puppet:///modules/grafana/vhost.conf',
  }
}
