# == Class: grafana
#
# Set up grafana.
#
class grafana {
  include grafana::repo
  include grafana::dashboards

  package { 'grafana':
    ensure  => latest,
    require => Class['grafana::repo'],
  }

  service { 'grafana-server':
    ensure  => 'running',
    enable  => true,
    require => File['/etc/grafana/grafana.ini'],
  }

  file { '/etc/grafana/grafana.ini':
    ensure  => file,
    source  => 'puppet:///modules/grafana/grafana.ini',
    require => Package['grafana'],
  }

  nginx::config::site { 'grafana':
    source => 'puppet:///modules/grafana/vhost.conf',
  }

  # FIXME: remove this code once all grafanasa are upgraded from 1.9
  file { '/etc/grafana/config.js':
    ensure => absent,
  }

}
