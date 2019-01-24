# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::publicapi (
  $privateapi_ssl = true,
) {
  govuk::app::publicapi { 'live-publicapi':
    privateapi_ssl => $privateapi_ssl,
    prefix         => '',
  }
}
