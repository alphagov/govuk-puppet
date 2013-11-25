class govuk::node::s_backend_lb {
  include govuk::node::s_base
  include loadbalancer

  $backend_servers = extlookup('lb_nodes_backend')
  $mapit_servers = extlookup('lb_nodes_mapit')
  $datainsight_servers = ['datainsight-1']
  $app_domain = extlookup('app_domain')

  Loadbalancer::Balance {
    servers => $backend_servers,
  }

  loadbalancer::balance {
    [
      'contacts',
      'content-planner',
      'fact-cave',
      'imminence',
      'maslow',
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
      https_only => false; # FIXME: Remove for #51136581
    [
      'asset-manager',
      'canary-backend',
      'contentapi',
      'need-api',
      'govuk-delivery',
      'search',
      'tariff-api',
    ]:
      https_only    => false, # FIXME: Remove for #51136581
      internal_only => true;
  }

  loadbalancer::balance { 'kibana':
    read_timeout => 5,
    https_only   => false, # FIXME: Remove for #51136581
  }

  loadbalancer::balance { 'mapit':
    servers           => $mapit_servers,
    internal_only     => true,
    https_only        => false, # FIXME: Remove for #51136581
  }

  $perfplat_app_domain = extlookup('perfplat_app_domain', 'performance.service.gov.uk')
  nginx::config::vhost::redirect { "backdrop-admin.${app_domain}" :
    to => "https://admin.${perfplat_app_domain}/",
  }
}
