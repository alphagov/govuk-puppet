class graphite::client {

  include nodejs

  package { 'statsd':
    ensure  => present,
    require => Package['nodejs'],
  }

  file { '/etc/statsd.conf':
    source => 'puppet:///modules/graphite/etc/statsd.conf'
  }

  file { '/etc/init/statsd.conf':
    source  => 'puppet:///modules/graphite/etc/init/statsd.conf',
    require => [Package['statsd'], File['/etc/statsd.conf']],
  }

  file { '/etc/statsd/scripts':
    ensure  => directory,
    recurse => true,
    purge   => true,
    force   => true,
  }

  service { 'statsd':
    ensure    => running,
    subscribe => [File['/etc/init/statsd.conf'], File['/etc/statsd.conf']],
  }

  Graphite::Cronjob <| |>
}
