class govuk::node::s_frontend_lb {
  include govuk::node::s_base
  include loadbalancer

  $govuk_frontend_servers = ["frontend-1", "frontend-2", "frontend-3"]
  $whitehall_frontend_servers = ["whitehall-frontend-1", "whitehall-frontend-2",]

  $app_domain = extlookup('app_domain')

  # Some idiot (Hi!) named something that's a URL 'host'. Sorry. -NS
  $asset_url = extlookup('asset_host')
  $asset_host = regsubst($asset_url, "https?://(.+)", '\1')

  Loadbalancer::Balance {
    internal_only     => true,
    servers           => $govuk_frontend_servers,
  }

  $hide_frontend_apps = !str2bool(extlookup('expose_frontend_apps_directly', 'no'))

  loadbalancer::balance {
    [
      'businesssupportfinder',
      'calendars',
      'canary-frontend',
      'datainsight-frontend',
      'designprinciples',
      'feedback',
      'licencefinder',
      'limelight',
      'smartanswers',
      'transaction-wrappers',
      'tariff',
      'tariff-demo',
    ]:
      internal_only => $hide_frontend_apps;
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

  # public api
  include govuk::apps::publicapi
}
