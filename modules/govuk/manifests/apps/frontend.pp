class govuk::apps::frontend(
  $port = 3005,
  $vhost_protected = false
) {

  $app_domain = extlookup('app_domain')

  govuk::app { 'frontend':
    app_type               => 'rack',
    port                   => $port,
    vhost_protected        => $vhost_protected,
    vhost_aliases          => ['private-frontend'],
    health_check_path      => '/',
    log_format_is_json     => true,
  }

  # Remove the symlink that used to exist.
  # This block can be removed once it has run everywhere.
  file { "/data/vhost/www.${app_domain}":
    ensure => absent,
  }
}
