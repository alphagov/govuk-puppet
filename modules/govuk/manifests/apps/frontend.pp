class govuk::apps::frontend(
  $port = 3005,
  $vhost_protected = false
) {

  $app_domain = extlookup('app_domain')

  govuk::app { 'frontend':
    app_type               => 'rack',
    port                   => $port,
    vhost_protected        => $vhost_protected,
    vhost_aliases          => ['private-frontend', 'www'], # TODO: Remove the www alias once we're sure it's not being used.
    health_check_path      => '/',
    log_format_is_json     => true,
  }

  # Frontend used to be deployed to /data/vhost/www.${app_domain}. Leave this
  # symlink in place until we're sure that nothing needs it any more.
  file { "/data/vhost/www.${app_domain}":
    ensure => link,
    target => "/data/vhost/frontend.${app_domain}",
    owner  => 'deploy',
    group  => 'deploy',
  }
}
