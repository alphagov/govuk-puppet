# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_frontend_lb (
  $whitehall_frontend_servers,
){
  include govuk::node::s_base
  include loadbalancer

  Loadbalancer::Balance {
    internal_only => true,
  }

  loadbalancer::balance {
    [
      'whitehall-frontend',
      'draft-whitehall-frontend',
    ]:
      servers       => $whitehall_frontend_servers;
  }
}
