# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::draft_publicapi (
  $privateapi_ssl = true,
) {
  govuk::app::publicapi { 'draft-publicapi':
    privateapi_ssl => $privateapi_ssl,
    prefix         => 'draft-',
  }
}
