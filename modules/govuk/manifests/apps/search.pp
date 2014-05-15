class govuk::apps::search( $port = 3009, $enable_delayed_job_worker = true ) {
  include aspell

  # Enable raindrops monitoring
  collectd::plugin::raindrops { 'search':
    port => $port,
  }

  govuk::app { 'search':
    app_type           => 'rack',
    port               => $port,
    health_check_path  => '/unified_search?q=search_healthcheck',
    log_format_is_json => true,
    nginx_extra_config => '
    client_max_body_size 500m;

    location ^~ /sitemap.xml {
      expires 1d;
      add_header Cache-Control public;
    }
    location ^~ /sitemaps/ {
      expires 1d;
      add_header Cache-Control public;
    }
    ',
  }

  class { 'collectd::plugin::search':
    app_port => $port
  }

  govuk::delayed_job::worker { 'search':
    enable_service => $enable_delayed_job_worker,
  }
}
