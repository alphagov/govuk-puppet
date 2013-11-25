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
      'business-support-api',
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

  $perfplat_app_domain = extlookup('perfplat_app_domain', 'performance.service.gov.uk')
  nginx::config::vhost::redirect { "backdrop-admin.${app_domain}" :
    to => "https://admin.${perfplat_app_domain}/",
  }
}
