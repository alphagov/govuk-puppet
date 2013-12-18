class govuk::apps::need_api( $port = 3052 ) {
  govuk::app { 'need-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => hiera('govuk_leverage_json_app_log', false),
  }

  govuk::logstream { 'need-api-org-import-json-log':
    logfile       => '/var/apps/need-api/log/organisation_import.json.log',
    fields        => {'application' => 'need-api'},
    json          => true,
  }
}
