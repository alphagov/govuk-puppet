class graphite::client {
  include govuk::repository
  package{ 'statsd':
    ensure  => present,
    require => [Apt::Deb_repository['gds']]
  }

  file { '/etc/statsd.conf':
    source => 'puppet:///modules/graphite/statsd.conf'
  }
}