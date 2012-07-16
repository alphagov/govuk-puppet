class graphite::client {
  include govuk::repository
  package{ 'statsd':
    ensure  => present,
    require => [Apt::Deb_repository['gds']]
  }

  file { '/etc/statsd.conf':
    source => 'puppet:///modules/graphite/etc/statsd.conf'
  }

  file { '/etc/init/statsd.conf':
    source  => 'puppet:///modules/graphite/etc/init/statsd.conf',
    require =>  [Package[statsd], File['/etc/statsd.conf']],
  }

  service { 'statsd':
    ensure    => running,
    provider  => upstart,
    subscribe => File['/etc/init/statsd.conf'],
    require   => [File['/etc/init/statsd.conf'], File['/etc/statsd.conf']],
  }

}