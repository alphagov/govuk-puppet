class nginx::config::router {

  include govuk::htpasswd

  nginx::config::site { 'default':
    source => "puppet:///modules/nginx/router_$::govuk_platform",
  }
  # The cache/router also contains a flat site as a backup for software failures
  nginx::config::vhost::mirror { "flatsite.${::govuk_platform}.alphagov.co.uk":
    port     => "444",
    certtype => 'wildcard_alphagov',
  }

  if $::govuk_platform == 'production' {
    nginx::config::ssl { 'www.gov.uk': certtype => 'www' }
  } else {
    nginx::config::ssl { "www.$::govuk_platform.alphagov.co.uk": certtype => 'www' }
  }

  @@nagios::check { "check_nginx_5xx_on_${::hostname}":
    check_command       => 'check_ganglia_metric!nginx_http_5xx!0.05!0.1',
    service_description => 'check nginx error rate',
    host_name           => "${::govuk_class}-${::hostname}",
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
