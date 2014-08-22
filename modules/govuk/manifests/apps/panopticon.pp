# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::panopticon( $port = 3003 ) {
  govuk::app { 'panopticon':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/',
    log_format_is_json => true,
    asset_pipeline     => true,
    deny_framing       => true,
  }

  govuk::logstream { 'panopticon-org-import-json-log':
    logfile => '/var/apps/panopticon/log/organisation_import.json.log',
    fields  => {'application' => 'panopticon'},
    json    => true,
  }
}
