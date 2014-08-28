# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_api_lb (
  $api_backend_servers,
  $content_store_backend_servers
) {
  include govuk::node::s_base
  include loadbalancer

  validate_array($api_backend_servers)
  validate_array($content_store_backend_servers)

  loadbalancer::balance {
    ['metadata-api']:
      servers       => $api_backend_servers,
      internal_only => true;
  }

  loadbalancer::balance {
    [
      'content-store',
      'publishing-api',
    ]:
      servers       => $content_store_backend_servers,
      internal_only => true;
  }
}
