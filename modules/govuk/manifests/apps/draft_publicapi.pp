# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::apps::draft_publicapi (
  $backdrop_protocol = 'https',
  $backdrop_host = 'www.performance.service.gov.uk',
  $privateapi_ssl = true,
) {
  govuk::app::publicapi { 'draft-publicapi':
    backdrop_protocol => $backdrop_protocol,
    backdrop_host     => $backdrop_host,
    privateapi_ssl    => $privateapi_ssl,
    prefix            => 'draft-',
  }
}
