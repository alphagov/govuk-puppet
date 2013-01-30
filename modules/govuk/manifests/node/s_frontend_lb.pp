class govuk::node::s_frontend_lb {
  include govuk::node::s_base
  include loadbalancer

  $govuk_frontend_servers = ["frontend-1", "frontend-2", "frontend-3"]
  $extra_smartanswers_servers = extlookup("extra_smartanswers_servers",[])
  $whitehall_frontend_servers = ["whitehall-frontend-1", "whitehall-frontend-2",]
  $efg_frontend_servers = ["efg-frontend-1"]

  $app_domain = extlookup('app_domain')

  # Some idiot (Hi!) named something that's a URL 'host'. Sorry. -NS
  $asset_url = extlookup('asset_host')
  $asset_host = regsubst($asset_url, "https?://(.+)", '\1')

  Loadbalancer::Balance {
    internal_only     => true,
    servers           => $govuk_frontend_servers,
  }

  loadbalancer::balance {
    [
      'businesssupportfinder',
      'calendars',
      'canary-frontend',
      'datainsight-frontend',
      'designprinciples',
      'feedback',
      'licencefinder',
      'tariff',
    ]:
      ;
    'efg':
      internal_only => false,
      servers       => $efg_frontend_servers;
    'frontend':
      aliases       => ["www.${app_domain}"]; # TODO: remove this alias once we're sure it's not being used.
    'smartanswers':
      servers       => flatten([$govuk_frontend_servers,$extra_smartanswers_servers]);
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
