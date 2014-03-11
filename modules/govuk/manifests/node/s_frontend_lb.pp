class govuk::node::s_frontend_lb (
  $govuk_frontend_servers,
  $whitehall_frontend_servers,
  $calculators_frontend_servers
){
  include govuk::node::s_base
  include loadbalancer

  $hide_frontend_apps = !str2bool(extlookup('expose_frontend_apps_directly', 'no'))

  Loadbalancer::Balance {
    https_only    => false, # Varnish/Router can't speak HTTPS.
    internal_only => $hide_frontend_apps,
  }

  loadbalancer::balance {
    [
      'canary-frontend',
      'collections',
      'contacts-frontend',
      'designprinciples',
      'feedback',
      'frontend',
      'manuals-frontend',
      'specialist-frontend',
      'static',
      'limelight',
      'transactions-explorer',
    ]:
      servers       => $govuk_frontend_servers;
    [
      'businesssupportfinder',
      'calculators',
      'calendars',
      'finder-frontend',
      'licencefinder',
      'smartanswers',
      'transaction-wrappers',
      'tariff',
    ]:
      servers       => $calculators_frontend_servers;
    'whitehall-frontend':
      servers       => $whitehall_frontend_servers;
  }

  include govuk::apps::publicapi
  include govuk::apps::public_link_tracker

  include performance_platform::spotlight
}
