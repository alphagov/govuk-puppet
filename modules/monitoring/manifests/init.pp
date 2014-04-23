class monitoring {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include icinga
  include nsca::server

  include govuk::htpasswd

  # Include monitoring-server-only checks
  include monitoring::checks

  # FIXME: Remove when logstream has been stopped.
  nginx::log { [
    'monitoring-json.event.access.log',
    'monitoring-error.log']:
    logstream => absent;
  }

  # FIXME: Remove when deployed.
  file { [
    '/etc/nginx/ssl/monitoring.crt',
    '/etc/nginx/ssl/monitoring.key']:
    ensure => absent,
  }

  # FIXME: Remove when deployed.
  file { '/var/www/monitoring':
    ensure  => absent,
    recurse => true,
    purge   => true,
    backup  => false,
  }

}
