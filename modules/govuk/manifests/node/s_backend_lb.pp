class govuk::node::s_backend_lb (
  $perfplat_public_app_domain = 'performance.service.gov.uk',
) {
  include govuk::node::s_base
  include loadbalancer

  $backend_servers = extlookup('lb_nodes_backend')
  $whitehall_backend_servers = extlookup('lb_nodes_whitehall_backend')
  $mapit_servers = extlookup('lb_nodes_mapit')
  $errbit_servers = ['exception-handler-1']
  $app_domain = hiera('app_domain')

  Loadbalancer::Balance {
    servers => $backend_servers,
  }

  loadbalancer::balance {
    [
      'business-support-api',
      'contacts-admin',
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
      'specialist-publisher',
      'support',
      'tariff-admin',
      'travel-advice-publisher',
      'transition',
    ]:
      https_only => false; # FIXME: Remove for #51136581
    [
      'api-external-link-tracker',
      'asset-manager',
      'canary-backend',
      'contentapi',
      'external-link-tracker',
      'finder-api',
      'need-api',
      'govuk-delivery',
      'search',
      'tariff-api',
    ]:
      https_only    => false, # FIXME: Remove for #51136581
      internal_only => true;
    'whitehall-admin':
      https_only => false, # FIXME: Remove for #51136581
      servers    => $whitehall_backend_servers;
  }

  loadbalancer::balance { 'errbit':
    servers      => $errbit_servers,
    https_only   => false, # FIXME: Remove for #51136581
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

  nginx::config::vhost::redirect { "backdrop-admin.${app_domain}" :
    to => "https://admin.${perfplat_public_app_domain}/",
  }
}
