class monitoring {

  package { 'apache2':
    ensure => 'purged',
  }

  package { 'python-rrdtool':
    ensure => 'installed',
  }

  include nagios
  include ganglia
  include graphite

  include govuk::htpasswd

  $platform = $::govuk_platform

  $domain = $platform ? {
    'development' => 'dev.gov.uk',
    default       => "${platform}.alphagov.co.uk",
  }

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
