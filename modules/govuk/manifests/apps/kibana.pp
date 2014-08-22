# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::kibana( $port = 3202 ) {
  govuk::app { 'kibana':
    app_type => 'rack',
    port     => $port,
  }
}
