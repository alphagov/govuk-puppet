# FIXME: This class needs better documentation as per https://docs.puppetlabs.com/guides/style_guide.html#puppet-doc
class govuk::node::s_frontend_lb (
  $calculators_frontend_servers,
  $draft_frontend_servers,
  $frontend_servers,
  $whitehall_frontend_servers,
  $hide_frontend_apps = true,
  $performance_frontend_apps = [],
  $performance_frontend_servers = [],
){
  include govuk::node::s_base
  include loadbalancer

  Loadbalancer::Balance {
    https_only    => false, # Varnish/Router can't speak HTTPS.
    internal_only => $hide_frontend_apps,
  }

  loadbalancer::balance {
    [
      'draft-collections',
      'draft-contacts-frontend',
      'draft-email-alert-frontend',
      'draft-government-frontend',
      'draft-manuals-frontend',
      'draft-specialist-frontend',
      'draft-static',
    ]:
      servers       => $draft_frontend_servers;
    [
      'canary-frontend',
      'collections',
      'contacts-frontend',
      'contacts-frontend-old',
      'courts-frontend',
      'designprinciples',
      'email-alert-frontend',
      'feedback',
      'frontend',
      'government-frontend',
      'info-frontend',
      'manuals-frontend',
      'service-manual',
      'specialist-frontend',
      'static',
    ]:
      servers       => $frontend_servers;
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
    $performance_frontend_apps:
      servers       => $performance_frontend_servers;
  }

  include govuk::apps::publicapi
  include govuk::apps::public_event_store
  include govuk::apps::public_link_tracker

  # FIXME: Remove these 4 lines once Spotlight is running in production.
  #        You might also want to ensure that the vhost is removed from disk.
  if (!('spotlight' in $performance_frontend_apps)) {
    include performance_platform::spotlight
  }
  include performance_platform::spotlight_proxy
}
