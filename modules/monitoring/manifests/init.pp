class monitoring {

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include nagios
  include nsca::server
  include ganglia::remove
  include graphite

  include govuk::htpasswd

  # Include monitoring-server-only checks
  include monitoring::checks

  $enable_ssl = str2bool(extlookup('nginx_enable_ssl', 'yes'))

  nginx::config::ssl { 'monitoring':
    certtype => 'wildcard_alphagov_mgmt',
  }
  nginx::config::site { 'monitoring':
    content => template('monitoring/nginx.conf.erb'),
  }
  nginx::log {  [
                  'monitoring-access.log',
                  'monitoring-error.log'
                ]:
                  logstream => true;
  }

  file { '/var/www/monitoring':
    ensure => directory,
  }

  file { '/var/www/monitoring/index.html':
    ensure  => present,
    source  => 'puppet:///modules/monitoring/index.html',
    require => File['/var/www/monitoring'],
  }

  # FIXME [#45082195]: No longer required.
  file { '/opt/graphite/storage/rrd/ganglia':
    ensure => absent,
  }

  # FIXME [#45082195]: No longer required.
  file { '/var/www/ganglia-views':
    ensure  => absent,
    recurse => true,
    force   => true,
    purge   => true,
    backup  => false,
  }

}
