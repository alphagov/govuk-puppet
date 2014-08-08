class monitoring {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include icinga
  include nsca::server

  include govuk::htpasswd

  # Include monitoring-server-only checks
  include monitoring::checks

  # FIXME: Remove when deployed.
  file { '/var/www/monitoring':
    ensure  => absent,
    recurse => true,
    purge   => true,
    backup  => false,
  }

}
