class monitoring {

  # because this is a monitoring server, we install
  # nagios3-cgi which has apache2 as a Recommends:
  # so it may get unintentionally installed. This
  # gets rid of it in that eventuality.
  package { 'apache2':
    ensure => 'purged',
  }
  service { 'apache2':
    ensure => 'stopped',
  }

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include nagios
  include ganglia
  include graphite

  include govuk::htpasswd

  $platform = $::govuk_platform
  $domain = extlookup('app_domain')
  $vhost = "monitoring.${domain}"

  nginx::config::ssl { $vhost: certtype => 'wildcard_alphagov' }
  nginx::config::site { $vhost:
    content => template('monitoring/nginx.conf.erb'),
  }

  file { '/opt/graphite/storage/rrd/ganglia':
    ensure => link,
    target => '/var/lib/ganglia/rrds/GDS/',
  }

  file { '/var/www/monitoring':
    ensure => directory,
  }

  file { '/var/www/monitoring/index.html':
    ensure  => present,
    content => template('monitoring/index.html.erb'),
    require => File['/var/www/monitoring'],
  }

}
