class govuk::apps::backdrop_admin {

  $app_domain = extlookup('app_domain')

  $backdropwrite = "write.backdrop.${app_domain}"

  $app_name = 'backdrop-admin'
  $full_domain = "${app_name}.${app_domain}"

  nginx::config::vhost::proxy { $full_domain:
    to               => [$backdropwrite],
    protected        => false,
    ssl_only         => false
  }
}
