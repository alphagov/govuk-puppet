class govuk::apps::bouncer(
  $port = 3049,
  $vhost_protected = false
) {

  govuk::app { 'bouncer':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => false,
    health_check_path  => '/healthcheck',
    vhost_protected    => false,
    # Disable the default nginx config, as we need a custom
    # one to allow us to set up wildcard alias
    enable_nginx_vhost => false
  }

  $app_domain = hiera('app_domain')

  # Nginx proxy config with wildcard alias
  govuk::app::nginx_vhost { 'bouncer':
    vhost                  => "bouncer.${app_domain}",
    app_port               => $port,
    ssl_only               => false,
    is_default_vhost       => true
  }

  file { '/etc/nginx/sites-available/ukba.homeoffice.gov.uk':
    ensure  => present,
    require => Class['nginx::package'],
    notify  => Class['nginx::service'],
    source  => 'puppet:///modules/bouncer/www.ukba.homeoffice.gov.uk_nginx.conf',
  }

  file { '/etc/nginx/sites-enabled/ukba.homeoffice.gov.uk':
    ensure  => link,
    target  => '/etc/nginx/sites-available/ukba.homeoffice.gov.uk',
    require => [Class['nginx::package'], File['/etc/nginx/sites-available/ukba.homeoffice.gov.uk']],
    notify  => Class['nginx::service']
  }

  nginx::log {
    'www.ukba.homeoffice.gov.uk-json.event.access.log':
      json          => true,
      logstream     => true,
  }
}
