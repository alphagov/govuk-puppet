# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::support_api($port = 3075, $enable_procfile_worker = true) {
  govuk::app { 'support-api':
    app_type           => 'rack',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/healthcheck',
    log_format_is_json => true,
  }

  govuk::procfile::worker { 'support-api':
    enable_service => $enable_procfile_worker,
  }
}
