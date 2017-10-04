# == Class: grafana
#
# Set up grafana.
#
class grafana {
  include grafana::repo

  package { 'grafana':
    ensure  => 'absent',
    require => Class['grafana::repo'],
  }

  service { 'grafana-server':
    ensure  => 'stopped',
  }

  if $::aws_migration {
    nginx::config::vhost::proxy { 'grafana':
      to     => ['localhost:3204'],
      ensure => 'absent',
    }
  } else {
    nginx::config::site { 'grafana':
      ensure => 'absent',
    }
  }

}
