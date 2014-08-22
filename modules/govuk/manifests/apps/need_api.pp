# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::need_api( $port = 3052 ) {
  govuk::app { 'need-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  govuk::logstream { 'need-api-org-import-json-log':
    logfile => '/var/apps/need-api/log/organisation_import.json.log',
    fields  => {'application' => 'need-api'},
    json    => true,
  }
}
