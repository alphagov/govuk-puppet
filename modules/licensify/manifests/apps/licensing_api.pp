# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class licensify::apps::licensing_api( $port = 9100 ) inherits licensify::apps::base {

  govuk::app { 'licensing-api':
    app_type        => 'procfile',
    port            => $port,
    vhost_protected => false,
    # health_check_path => '/login', TODO
  }
}
