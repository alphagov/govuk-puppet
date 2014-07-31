class govuk::apps::transition( $port = 3044, $enable_procfile_worker = true ) {
  include postgresql::lib::devel #installs libpq-dev package needed for pg gem
  govuk::app { 'transition':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    vhost_protected    => false,
    deny_framing       => true,
  }

  govuk::procfile::worker {'transition':
    enable_service => $enable_procfile_worker,
  }
}
