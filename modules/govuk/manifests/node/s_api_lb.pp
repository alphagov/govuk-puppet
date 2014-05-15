class govuk::node::s_api_lb (
  $content_store_backend_servers
) {
  include govuk::node::s_base
  include loadbalancer

  validate_array($content_store_backend_servers)

  loadbalancer::balance {
    [
      'content-store',
    ]:
      servers       => $content_store_backend_servers,
      internal_only => true;
  }
}
