class monitoring {

  package { 'apache2':
    ensure => 'purged',
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

  file { '/var/www/monitoring':
    ensure => directory,
  }

  file { '/var/www/monitoring/index.html':
    ensure  => present,
    content => template('monitoring/index.html.erb'),
    require => File['/var/www/monitoring'],
  }

}
