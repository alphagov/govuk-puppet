class govuk::apps::search_admin(
  $port = 3073,
  $vhost_protected = true,
) {

  govuk::app { 'search-admin':
    app_type               => 'rack',
    port                   => $port,
    vhost_protected        => $vhost_protected,
    health_check_path      => '/best-bets',
    log_format_is_json     => true,
  }
}
