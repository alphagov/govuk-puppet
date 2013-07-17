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
  }

  if str2bool(extlookup('govuk_enable_search_worker', 'no')) {
    govuk::delayed_job::worker { 'search': }
  }
}
