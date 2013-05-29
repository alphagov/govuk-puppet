class govuk::node::s_backend_lb {
  include govuk::node::s_base
  include loadbalancer

  $backend_servers = extlookup('lb_nodes_backend')
  $mapit_servers = extlookup('lb_nodes_mapit')

  Loadbalancer::Balance {
    servers => $backend_servers,
  }

  loadbalancer::balance {
    [
      'imminence',
      'needotron',
      'panopticon',
      'private-frontend',
      'publisher',
      'release',
      'signon',
      'support',
      'travel-advice-publisher',
      'transition',
      'whitehall-admin',
    ]:
      ;
    [
      'asset-manager',
      'canary-backend',
      'contentapi',
      'govuk-delivery',
      'search',
      'tariff-api',
      'tariff-demo-api',
    ]:
      internal_only => true;
  }

  loadbalancer::balance { 'kibana':
    read_timeout => 5,
  }

  loadbalancer::balance { 'mapit':
    servers           => $mapit_servers,
    internal_only     => true,
  }
}
