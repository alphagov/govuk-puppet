class govuk::apps::search( $port = 3009 ) {
  include aspell

  # Enable raindrops monitoring
  collectd::plugin::raindrops { 'search':
    port => $port,
  }

  govuk::app { 'search':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/mainstream/search?q=search_healthcheck',
    log_format_is_json => true,
    nginx_extra_config => '
    client_max_body_size 500m;
    ',
  }

  class { 'collectd::plugin::search':
    app_port => $port
  }

  govuk::delayed_job::worker { 'search': }
}
