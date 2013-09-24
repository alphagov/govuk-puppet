class govuk::node::s_backend_lb {
  include govuk::node::s_base
  include loadbalancer

  $backend_servers = extlookup('lb_nodes_backend')
  $mapit_servers = extlookup('lb_nodes_mapit')
  $datainsight_servers = ['datainsight-1']

  Loadbalancer::Balance {
    servers => $backend_servers,
  }

  loadbalancer::balance {
    [
      'contacts',
      'fact-cave',
      'imminence',
      'needotron',
      'panopticon',
      'private-frontend',
      'publisher',
      'release',
      'signon',
      'support',
      'tariff-admin',
      'travel-advice-publisher',
      'transition',
      'whitehall-admin',
    ]:
      ;
    [
      'asset-manager',
      'canary-backend',
      'contentapi',
      'need-api',
      'govuk-delivery',
      'search',
      'tariff-api',
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

  loadbalancer::balance { 'backdrop-admin':
    servers => $datainsight_servers,
  }
}
