class govuk::node::s_frontend_lb {
  include govuk::node::s_base
  include loadbalancer

  $govuk_frontend_servers = extlookup('lb_nodes_frontend')
  $calculators_frontend_servers = extlookup('lb_nodes_calculators_frontend')
  $whitehall_frontend_servers = extlookup('lb_nodes_whitehall_frontend')

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
      'frontend',
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
      servers       => $calculators_frontend_servers;
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
