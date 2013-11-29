class govuk::node::s_backend_lb {
  include govuk::node::s_base
  include loadbalancer

  $backend_servers = extlookup('lb_nodes_backend')
  $whitehall_backend_servers = extlookup('lb_nodes_whitehall_backend')
  $mapit_servers = extlookup('lb_nodes_mapit')
  $datainsight_servers = ['datainsight-1']
  $app_domain = extlookup('app_domain')

  if str2bool(extlookup('govuk_enable_whitehall_backend_machines', 'no')) {
    $whitehall_backend_servers_to_use = $whitehall_backend_servers
  } else {
    $whitehall_backend_servers_to_use = $backend_servers
  }

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
    'whitehall-admin':
      https_only => false, # FIXME: Remove for #51136581
      servers    => $whitehall_backend_servers_to_use;
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
