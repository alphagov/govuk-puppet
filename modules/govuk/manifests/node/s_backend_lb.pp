class govuk::node::s_backend_lb {
  include govuk::node::s_base
  include loadbalancer

  $backend_servers = ["backend-1", "backend-2", "backend-3"]
  $mapit_servers = ["mapit-server-1", "mapit-server-2"]

  Loadbalancer::Balance {
    servers => $backend_servers,
  }

  loadbalancer::balance {
    [
      'imminence',
      'migratorator',
      'needotron',
      'panopticon',
      'private-frontend',
      'publisher',
      'release',
      'signon',
      'support',
      'travel-advice-publisher',
      'whitehall-admin',
    ]:
      ;
    [
      'asset-manager',
      'canary-backend',
      'contentapi',
      'search',
      'tariff-api',
    ]:
      internal_only => true;
  }

  if str2bool(extlookup('govuk_enable_kibana', 'no')) {
    loadbalancer::balance { 'kibana':
      read_timeout => 5,
    }
  }

  loadbalancer::balance { 'mapit':
    servers           => $mapit_servers,
    internal_only     => true,
  }
}
