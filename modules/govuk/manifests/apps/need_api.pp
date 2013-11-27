class govuk::apps::need_api( $port = 3052 ) {
  govuk::app { 'need-api':
    app_type          => 'rack',
    port              => $port,
    vhost_ssl_only    => true,
    health_check_path => '/healthcheck',
  }

  govuk::logstream { 'need-api-org-import-json-log':
    logfile       => "/var/logs/need-api/organisation_import.json.log",
    fields        => {'application' => 'need-api'},
    json          => true,
  }
}
