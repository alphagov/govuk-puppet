# == Class: grafana
#
# Set up grafana.
#
class grafana {
  include grafana::repo
  include grafana::dashboards

  package { 'grafana':
    ensure  => '3.1.1-1470047149',
    require => Class['grafana::repo'],
  }

  Package['grafana'] -> Class['grafana::dashboards']

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

  if $::aws_migration {
    nginx::config::vhost::proxy { 'grafana':
      to           => ['localhost:3204'],
      root         => '/usr/share/grafana',
      aliases      => ['grafana.*'],
      protected    => false,
      ssl_only     => true,
      ssl_certtype => 'wildcard_publishing',
    }
  } else {
    nginx::config::site { 'grafana':
      source => 'puppet:///modules/grafana/vhost.conf',
    }
  }

}
