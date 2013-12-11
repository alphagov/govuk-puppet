class govuk::node::s_frontend_lb {
  include govuk::node::s_base
  include loadbalancer

  $govuk_frontend_servers = extlookup('lb_nodes_frontend')
  $calculators_frontend_servers = extlookup('lb_nodes_calculators_frontend')
  $whitehall_frontend_servers = extlookup('lb_nodes_whitehall_frontend')

  $app_domain = extlookup('app_domain')

  if hiera('govuk_enable_calculators_frontend_machines', false) {
    $calculators_frontend_servers_to_use = $calculators_frontend_servers
  } else {
    $calculators_frontend_servers_to_use = $govuk_frontend_servers
  }

  # Some idiot (Hi!) named something that's a URL 'host'. Sorry. -NS
  $asset_url = extlookup('asset_host')
  $asset_host = regsubst($asset_url, 'https?://(.+)', '\1')

  Loadbalancer::Balance {
    https_only    => false, # Varnish/Router can't speak HTTPS.
    internal_only => true,
    servers       => $govuk_frontend_servers,
  }

  $hide_frontend_apps = !str2bool(extlookup('expose_frontend_apps_directly', 'no'))

  loadbalancer::balance {
    [
      'canary-frontend',
      'datainsight-frontend',
      'designprinciples',
      'feedback',
      'limelight',
      'transactions-explorer',
    ]:
      internal_only => $hide_frontend_apps;
    [
      'businesssupportfinder',
      'calculators',
      'calendars',
      'fco-services',
      'licencefinder',
      'smartanswers',
      'transaction-wrappers',
      'tariff',
    ]:
      internal_only => $hide_frontend_apps,
      servers       => $calculators_frontend_servers_to_use;
    'frontend':
      internal_only => $hide_frontend_apps,
      aliases       => ["www.${app_domain}"]; # TODO: remove this alias once we're sure it's not being used.
    'static':
      internal_only => false,
      aliases       => [$asset_host];
    'whitehall-frontend':
      internal_only => false,
      servers       => $whitehall_frontend_servers;
  }

  include govuk::apps::publicapi

  include performance_platform::spotlight
}
