# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::govuk_delivery( $port = 3042, $enable_procfile_worker = true) {
  include govuk::python

  govuk::app { 'govuk-delivery':
    app_type           => 'procfile',
    port               => $port,
    vhost_ssl_only     => true,
    health_check_path  => '/_status',
    log_format_is_json => true;
  }

  govuk::procfile::worker { 'govuk-delivery':
    enable_service => $enable_procfile_worker,
  }
}
