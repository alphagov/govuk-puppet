class govuk::apps::signon( $port = 3016 ) {
  govuk::app { 'signon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/users/sign_in',
    log_format_is_json => true,
    vhost_aliases      => ['signonotron'],
    vhost_protected    => false,
    logstream          => absent,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  govuk::procfile::worker {'signon': }
}
