# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_api_lb (
  $api_backend_servers,
  $content_store_backend_servers,
  $search_backend_servers,
) {
  include govuk::node::s_base
  include loadbalancer

  validate_array($api_backend_servers)
  validate_array($content_store_backend_servers)
  validate_array($search_backend_servers)

  loadbalancer::balance {
    ['metadata-api']:
      servers       => $api_backend_servers,
      internal_only => true;
  }

  loadbalancer::balance {
    [
      'content-store',
    ]:
      servers       => $content_store_backend_servers,
      internal_only => true;
  }

  loadbalancer::balance {
    [
      'rummager',

      # support search as an alias for ease of migration from old
      # cluster running in backend VDC.
      'search',
    ]:
      servers       => $search_backend_servers,
      https_only    => false, # Necessary for the router to fetch sitemaps.
      internal_only => true;
  }
}
