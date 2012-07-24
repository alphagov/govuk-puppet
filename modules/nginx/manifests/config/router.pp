class nginx::config::router {
  file { '/etc/nginx/sites-enabled/default':
    ensure  => file,
    source  => "puppet:///modules/nginx/router_$::govuk_platform",
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }
  file { '/etc/htpasswd':
    ensure  => file,
    source  => 'puppet:///modules/nginx/htpasswd.default',
    require => Class['nginx::package'],
    notify  => Exec['nginx_reload'],
  }
  if $::govuk_platform == 'production' {
    $host = 'www.gov.uk'
  } else {
    $host = "www.$::govuk_platform.alphagov.co.uk"
  }
  file { "/etc/nginx/ssl/$host.crt":
    ensure  => present,
    content => extlookup("${host}_crt", ''),
  }
  file { "/etc/nginx/ssl/$host.key":
    ensure  => present,
    content => extlookup("${host}_key", ''),
  }
  @@nagios::check { "check_nginx_5xx_on_${::hostname}":
    check_command       => 'check_ganglia_metric!nginx_http_5xx!0.05!0.1',
    service_description => 'check nginx error rate',
    host_name           => "${::govuk_class}-${::hostname}",
  }
  cron { 'logster-nginx':
    command => '/usr/sbin/logster NginxGangliaLogster /var/log/nginx/lb-access.log',
    user    => root,
    minute  => '*/2'
  }
  graylogtail::collect { 'graylogtail-access':
    log_file => '/var/log/nginx/lb-access.log',
    facility => $name,
  }
  graylogtail::collect { 'graylogtail-errors':
    log_file => '/var/log/nginx/lb-error_log',
    facility => $name,
    level    => 'error',
  }
  file { '/var/www/fallback':
    ensure => directory,
    owner  => 'deploy',
    group  => 'deploy',
  }
  file { '/var/www/fallback/fallback_holding.html':
    ensure => file,
    source => 'puppet:///modules/nginx/fallback.html',
    owner  => 'deploy',
    group  => 'deploy',
  }
}
