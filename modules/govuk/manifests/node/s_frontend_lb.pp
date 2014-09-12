# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_frontend_lb (
  $govuk_frontend_servers,
  $whitehall_frontend_servers,
  $calculators_frontend_servers,
  $hide_frontend_apps = true,
){
  include govuk::node::s_base
  include loadbalancer

  Loadbalancer::Balance {
    https_only    => false, # Varnish/Router can't speak HTTPS.
    internal_only => $hide_frontend_apps,
  }

  loadbalancer::balance {
    [
      'canary-frontend',
      'collections',
      'contacts-frontend',
      'contacts-frontend-old',
      'designprinciples',
      'feedback',
      'frontend',
      'info-frontend',
      'manuals-frontend',
      'service-manual',
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
