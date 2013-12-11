class govuk::apps::frontend(
  $port = 3005,
  $vhost_protected = false
) {

  $app_domain = extlookup('app_domain')

  $nginx_extra_config = $::govuk_platform ? {
    'development' => '',
    default => '
  location ^~ /frontend/homepage/no-cache/ {
    expires epoch;
  }
'
  }

  govuk::app { 'frontend':
    app_type               => 'rack',
    port                   => $port,
    vhost_protected        => $vhost_protected,
    vhost_aliases          => ['private-frontend'],
    health_check_path      => '/',
    log_format_is_json     => true,
    asset_pipeline         => true,
    asset_pipeline_prefix  => 'frontend',
    nginx_extra_config     => $nginx_extra_config,
  }

  # Remove the symlink that used to exist.
  # This block can be removed once it has run everywhere.
  file { "/data/vhost/www.${app_domain}":
    ensure => absent,
  }
}
